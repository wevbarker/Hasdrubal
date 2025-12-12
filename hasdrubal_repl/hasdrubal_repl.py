#!/usr/bin/env python3
"""
Hasdrubal Interactive REPL with Split Panes

Interactive command-line interface for the Hasdrubal agent.
Uses split terminal view: upper pane for logs, lower for conversation.

Usage:
    source venv/bin/activate
    python AI/hasdrubal_repl.py
"""

import asyncio
import os
import sys
import logging
import json
import re
import uuid
import tty
import termios
import argparse
from pathlib import Path
from dotenv import load_dotenv
from datetime import datetime, timezone
from collections import deque

# Load environment
load_dotenv("config/.env")

# Add project root to path for local imports
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

# Import agent creator
import importlib.util
spec = importlib.util.spec_from_file_location("hasdrubal_agent", project_root / "hasdrubal_agent.py")
hasdrubal_agent = importlib.util.module_from_spec(spec)
spec.loader.exec_module(hasdrubal_agent)
create_hasdrubal_agent = hasdrubal_agent.create_hasdrubal_agent

# Import from agents package
from agents import Agent, Runner
from agents.mcp import MCPServerStdio

# ANSI codes
GRAY = '\033[90m'
RESET = '\033[0m'
CLEAR_SCREEN = '\033[2J'
MOVE_CURSOR = '\033[{};{}H'  # row, col
CLEAR_TO_END = '\033[0J'
GREEN_BOLD = '\033[1;32m'
LIGHT_BLUE_BOLD = '\033[1;96m'
PALE_RED_BOLD = '\033[1;91m'
YELLOW_BOLD = '\033[1;33m'

# Path to agent prompt files
AGENTS_DIR = Path(__file__).parent.parent / "hasdrubal_agent"


def load_prompt_file(filename: str) -> str:
    """Load a prompt file from hasdrubal_agent directory. Read fresh each time."""
    filepath = AGENTS_DIR / filename
    if filepath.exists():
        return filepath.read_text().strip()
    return ""


class SessionLogger:
    """Logs conversation to JSONL file."""

    def __init__(self, sessions_dir: Path, session_id: str = None):
        self.sessions_dir = sessions_dir
        self.sessions_dir.mkdir(exist_ok=True)
        self.session_id = session_id or str(uuid.uuid4())
        self.log_file = self.sessions_dir / f"{self.session_id}.jsonl"
        self.file_handle = open(self.log_file, 'a')

    def log(self, entry_type: str, content: str, **kwargs):
        """Log an entry to the session file."""
        entry = {
            "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
            "type": entry_type,
            "content": content,
            **kwargs
        }
        self.file_handle.write(json.dumps(entry) + "\n")
        self.file_handle.flush()

    def log_user(self, message: str):
        self.log("user", message)

    def log_assistant(self, message: str):
        self.log("assistant", message)

    def log_tool_call(self, tool_name: str, arguments: dict):
        self.log("tool_call", tool_name, arguments=arguments)

    def log_tool_result(self, tool_name: str, result: str):
        self.log("tool_result", tool_name, result=result)

    def close(self):
        self.file_handle.close()


class SplitPaneDisplay:
    """Manages single-pane terminal display for conversation."""

    def __init__(self, term_height=40, term_width=120, split_ratio=0.65):
        self.term_height = term_height
        self.term_width = term_width

        # Buffer for conversation pane
        self.conv_buffer = deque(maxlen=500)

        # Scroll offset for conversation pane (0 = showing most recent)
        self.conv_scroll_offset = 0
        self.conv_visible_lines = term_height - 3

    def init_display(self):
        """Initialize the display."""
        print(CLEAR_SCREEN, end='')

    def add_log(self, text):
        """Log pane removed - silently ignore log messages."""
        pass

    def add_conv(self, text):
        """Add text to lower (conversation) pane."""
        max_width = self.term_width - 2  # Leave some margin

        # Extract any leading ANSI color code to propagate to wrapped lines
        ansi_pattern = re.compile(r'^(\033\[[0-9;]+m)+')

        # First split on newlines, then word-wrap each line
        for line in text.split('\n'):
            # Extract leading color code
            match = ansi_pattern.match(line)
            color_prefix = match.group(0) if match else ""

            # Calculate visible length (excluding ANSI codes)
            visible_line = re.sub(r'\033\[[0-9;]+m', '', line)

            if len(visible_line) > max_width:
                # Split into multiple lines, preserving color
                words = line.split()
                current_line = ""
                current_visible_len = 0
                is_first_segment = True

                for word in words:
                    # Calculate visible length of word (strip ANSI)
                    visible_word = re.sub(r'\033\[[0-9;]+m', '', word)

                    if current_visible_len + len(visible_word) + 1 <= max_width:
                        current_line += word + " "
                        current_visible_len += len(visible_word) + 1
                    else:
                        if current_line:
                            self.conv_buffer.append(current_line.rstrip())
                        # Continuation lines get the color prefix
                        if is_first_segment:
                            is_first_segment = False
                            current_line = word + " "
                        else:
                            current_line = color_prefix + word + " "
                        current_visible_len = len(visible_word) + 1

                if current_line:
                    self.conv_buffer.append(current_line.rstrip())
            else:
                self.conv_buffer.append(line)

        # Reset scroll to bottom when new content added
        self.conv_scroll_offset = 0
        self.redraw_conv_pane()
        self.restore_cursor_to_input()

    def scroll_up(self):
        """Scroll conversation pane up (view older content)."""
        max_scroll = max(0, len(self.conv_buffer) - self.conv_visible_lines)
        if self.conv_scroll_offset < max_scroll:
            self.conv_scroll_offset += 1
            self.redraw_conv_pane()
            self.restore_cursor_to_input()

    def scroll_down(self):
        """Scroll conversation pane down (view newer content)."""
        if self.conv_scroll_offset > 0:
            self.conv_scroll_offset -= 1
            self.redraw_conv_pane()
            self.restore_cursor_to_input()

    def restore_cursor_to_input(self):
        """Restore cursor to input row."""
        print(MOVE_CURSOR.format(self.get_input_row(), 3), end='', flush=True)

    def redraw_conv_pane(self):
        """Redraw conversation pane."""
        # Clear pane
        for i in range(self.term_height - 1):
            print(MOVE_CURSOR.format(i + 1, 1), end='')
            print(' ' * self.term_width, end='')

        # Calculate which lines to show based on scroll offset
        buffer_list = list(self.conv_buffer)
        total_lines = len(buffer_list)

        if total_lines <= self.conv_visible_lines:
            # All content fits, show everything
            visible_lines = buffer_list
        else:
            # Calculate start index based on scroll offset
            end_idx = total_lines - self.conv_scroll_offset
            start_idx = max(0, end_idx - self.conv_visible_lines)
            visible_lines = buffer_list[start_idx:end_idx]

        # Draw conversation content
        for i, line in enumerate(visible_lines):
            row = i + 1
            if row >= self.term_height:
                break
            print(MOVE_CURSOR.format(row, 1), end='')
            print(line[:self.term_width], end='', flush=True)

    def get_input_row(self):
        """Get row number for input prompt."""
        return self.term_height - 1


class LogCapture(logging.Handler):
    """Custom logging handler that captures to display."""

    def __init__(self, display):
        super().__init__()
        self.display = display

    def emit(self, record):
        try:
            msg = self.format(record)
            self.display.add_log(msg)
        except Exception:
            self.handleError(record)


def get_input_with_scroll(prompt, display):
    """Get user input while allowing arrow keys to scroll conversation pane."""
    print(prompt, end='', flush=True)

    # Save terminal settings
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)

    input_buffer = []
    cursor_pos = 0

    try:
        tty.setraw(fd)

        while True:
            char = sys.stdin.read(1)

            if char == '\r' or char == '\n':  # Enter
                # Restore terminal and return input
                termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
                print()  # Newline after input
                return ''.join(input_buffer)

            elif char == '\x03':  # Ctrl-C
                termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
                raise KeyboardInterrupt

            elif char == '\x04':  # Ctrl-D
                termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
                raise EOFError

            elif char == '\x1b':  # Escape sequence (arrow keys)
                next1 = sys.stdin.read(1)
                if next1 == '[':
                    next2 = sys.stdin.read(1)
                    if next2 == 'A':  # Up arrow
                        display.scroll_up()
                    elif next2 == 'B':  # Down arrow
                        display.scroll_down()
                    # Ignore left/right arrows for now

            elif char == '\x7f' or char == '\x08':  # Backspace
                if input_buffer and cursor_pos > 0:
                    input_buffer.pop(cursor_pos - 1)
                    cursor_pos -= 1
                    # Redraw input line
                    termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
                    print(MOVE_CURSOR.format(display.get_input_row(), 1), end='')
                    print(' ' * display.term_width, end='')
                    print(MOVE_CURSOR.format(display.get_input_row(), 1), end='')
                    print(prompt + ''.join(input_buffer), end='', flush=True)
                    tty.setraw(fd)

            elif char >= ' ' and char <= '~':  # Printable characters
                input_buffer.insert(cursor_pos, char)
                cursor_pos += 1
                # Echo character
                termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
                print(char, end='', flush=True)
                tty.setraw(fd)

    except Exception as e:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        raise


async def interactive_loop(agent, display, mcp_server, session_logger, initial_prompt=None, auto_mode=False):
    """Custom interactive loop with display."""

    # Maintain conversation history
    conversation_history = []

    # Track previous turn's tool calls for visibility hack
    previous_tool_calls = []

    # Queue initial prompt if provided via --file
    pending_initial_prompt = initial_prompt
    pending_is_auto = False  # Track if pending prompt is auto-injected "yes"
    pending_is_summary = False  # Track if pending prompt is summary solicitation

    while True:
        # Use initial prompt from --file or auto-injected "yes" if available
        if pending_initial_prompt:
            user_input = pending_initial_prompt
            is_auto_yes = pending_is_auto
            is_summary_response = pending_is_summary
            pending_initial_prompt = None
            pending_is_auto = False
            pending_is_summary = False
        else:
            is_auto_yes = False
            is_summary_response = False
            # Position cursor at input row
            print(MOVE_CURSOR.format(display.get_input_row(), 1), end='')
            print(' ' * display.term_width, end='')  # Clear line
            print(MOVE_CURSOR.format(display.get_input_row(), 1), end='')

            # Get user input with arrow key scrolling
            try:
                user_input = get_input_with_scroll("> ", display).strip()
            except (EOFError, KeyboardInterrupt):
                break

            if user_input.lower() in ['quit', 'exit', 'q']:
                break

            if not user_input:
                continue

        # Add user prompt to conversation pane (display clean input, log later with injection)
        if is_auto_yes:
            display.add_conv(f"{GREEN_BOLD}> [AUTO] {user_input}{RESET}")
        else:
            display.add_conv(f"{GREEN_BOLD}> {user_input}{RESET}")

        # Track Wolfram code for this turn (code + result pairs)
        wl_codes = []
        tool_call_records = []  # For visibility hack: stores (code, result) tuples

        # Wrap call_tool to capture WL code
        original_call_tool = mcp_server.call_tool
        async def capture_call_tool(tool_name, arguments):
            timestamp = datetime.now().strftime('%H:%M:%S.%f')[:-3]

            # Log tool call
            session_logger.log_tool_call(tool_name, arguments)

            # Execute
            result = await original_call_tool(tool_name, arguments)

            # Extract executed code and result from response
            wl_code = None
            result_text = ""
            messages_text = ""
            if hasattr(result, 'content') and result.content:
                full_result = result.content[0].text

                # Extract executed code from [Executed]...[/Executed] block
                import re
                executed_match = re.search(r'\[Executed\]\n(.*?)\n\[/Executed\]', full_result, re.DOTALL)
                if executed_match:
                    wl_code = executed_match.group(1)
                    # Remove the executed block from the result text
                    remaining = full_result[executed_match.end():].lstrip('\n')
                else:
                    # Fallback for unknown tools
                    wl_code = f"{tool_name}({arguments})"
                    remaining = full_result

                # Separate result from kernel messages
                if "\n\n[Kernel Messages]\n" in remaining:
                    result_text, messages_text = remaining.split("\n\n[Kernel Messages]\n", 1)
                else:
                    result_text = remaining

                # Log full result (including messages)
                session_logger.log_tool_result(tool_name, full_result)

                # Display in log pane
                display.add_log(f"{GRAY}[{timestamp}]{RESET} WOLFRAM: {wl_code}")
                display_text = result_text[:150] + "..." if len(result_text) > 150 else result_text
                display.add_log(f"{GRAY}[{timestamp}]{RESET} RESULT: {display_text}")
                if messages_text:
                    msg_display = messages_text[:100] + "..." if len(messages_text) > 100 else messages_text
                    display.add_log(f"{YELLOW_BOLD}[{timestamp}] MESSAGES: {msg_display}{RESET}")

            # Store for conversation pane and visibility hack
            if wl_code and tool_name.startswith("tool_"):
                wl_codes.append(wl_code)
                tool_call_records.append((wl_code, result_text, messages_text))

            return result

        mcp_server.call_tool = capture_call_tool

        # Run agent with conversation history
        try:
            # Build user message with visibility hack preamble if needed
            if previous_tool_calls:
                # Format previous tool calls
                tool_calls_text = []
                for i, (code, result_text, messages_text) in enumerate(previous_tool_calls, 1):
                    tool_calls_text.append(f"Tool call {i}: {code}")
                    # Truncate very long results
                    if len(result_text) > 500:
                        result_text = result_text[:500] + "... (truncated)"
                    tool_calls_text.append(f"Output: {result_text}")
                    if messages_text:
                        if len(messages_text) > 300:
                            messages_text = messages_text[:300] + "... (truncated)"
                        tool_calls_text.append(f"Kernel Messages: {messages_text}")
                    tool_calls_text.append("")

                # Load reminder template and substitute tool calls
                reminder_template = load_prompt_file("reminder.md")
                if reminder_template and "{tool_calls}" in reminder_template:
                    preamble = reminder_template.replace("{tool_calls}", "\n".join(tool_calls_text))
                else:
                    # Fallback if template missing or malformed
                    preamble = "[Tool calls from previous turn:\n" + "\n".join(tool_calls_text) + "]"

                augmented_input = f"{preamble}\n\nUser message:\n{user_input}"
            else:
                augmented_input = user_input

            # Log the full augmented input (including injection if present)
            if is_auto_yes:
                session_logger.log_user(f"[AUTO] {augmented_input}")
            else:
                session_logger.log_user(augmented_input)

            # Add user message to history (with preamble if applicable)
            conversation_history.append({"role": "user", "content": augmented_input})

            result = await Runner.run(agent, conversation_history)

            # Challenge: forgot tool call - agent replies without tool calls
            # Skip on first response (agent is just acknowledging the prompt)
            # Skip if agent is terminating (no tool call expected)
            # Skip if responding to summary solicitation (no tool call expected)
            is_first_response = len([m for m in conversation_history if m["role"] == "assistant"]) == 0
            is_terminating = "TERMINATE" in result.final_output
            if not tool_call_records and not is_first_response and not is_terminating and not is_summary_response:
                challenge_msg = load_prompt_file("challenge_forgot_tool_call.md")
                if challenge_msg:
                    response = result.final_output

                    # Log the agent's response before challenge
                    session_logger.log_assistant(response)
                    conversation_history.append({"role": "assistant", "content": response})

                    # Show agent response in conversation pane
                    display.add_conv(f"{LIGHT_BLUE_BOLD}Hasdrubal: {response}{RESET}")
                    display.add_conv("")

                    # Show and log challenge as automated user message
                    display.add_conv(f"{GREEN_BOLD}> [AUTO-CHALLENGE]{RESET}")
                    display.add_conv(f"{GREEN_BOLD}> {challenge_msg}{RESET}")
                    display.add_conv("")
                    session_logger.log_user(f"[AUTO-CHALLENGE] {challenge_msg}")
                    conversation_history.append({"role": "user", "content": challenge_msg})

                    display.add_log(f"{YELLOW_BOLD}Challenge: forgot_tool_call{RESET}")

                    # Clear and re-run
                    tool_call_records.clear()
                    result = await Runner.run(agent, conversation_history)

            # Show WL codes, outputs, and messages in conversation pane
            if tool_call_records:
                display.add_conv("")
                for code, output, messages in tool_call_records:
                    display.add_conv(f"{PALE_RED_BOLD}Wolfram Code:{RESET}")
                    display.add_conv(f"{PALE_RED_BOLD}  {code}{RESET}")
                    if output:
                        # Truncate very long outputs for display
                        output_display = output[:300] + "..." if len(output) > 300 else output
                        display.add_conv(f"{PALE_RED_BOLD}Output: {output_display}{RESET}")
                    if messages:
                        # Truncate very long messages for display
                        msg_display = messages[:200] + "..." if len(messages) > 200 else messages
                        display.add_conv(f"{YELLOW_BOLD}Messages: {msg_display}{RESET}")
                    display.add_conv("")

            # Show agent response in conversation pane
            response = result.final_output
            display.add_conv(f"{LIGHT_BLUE_BOLD}Hasdrubal: {response}{RESET}")
            display.add_conv("")

            # Log assistant response
            session_logger.log_assistant(response)

            # Add assistant response to history
            conversation_history.append({"role": "assistant", "content": response})

            # Check for challenge triggers (skip if responding to summary solicitation)
            challenges_triggered = []

            if not is_summary_response:
                # Challenge: cavalier constraint - agent mentions DefTensor
                if "DefTensor" in response:
                    challenges_triggered.append("challenge_cavalier_constraint.md")

                # Challenge: gloss over error - tool call had kernel messages (warnings/errors)
                if tool_call_records:
                    for code, output, messages in tool_call_records:
                        if messages:
                            challenges_triggered.append("challenge_gloss_over_error.md")
                            break

            # Issue challenges if any triggered (concatenated together)
            if challenges_triggered:
                challenge_msgs = []
                for challenge_file in challenges_triggered:
                    msg = load_prompt_file(challenge_file)
                    if msg:
                        challenge_msgs.append(msg)

                if challenge_msgs:
                    combined_challenge = "\n\n".join(challenge_msgs)
                    display.add_conv(f"{GREEN_BOLD}> [AUTO-CHALLENGE]{RESET}")
                    display.add_conv(f"{GREEN_BOLD}> {combined_challenge}{RESET}")
                    display.add_conv("")
                    session_logger.log_user(f"[AUTO-CHALLENGE] {combined_challenge}")
                    conversation_history.append({"role": "user", "content": combined_challenge})

                    display.add_log(f"{YELLOW_BOLD}Challenges triggered: {', '.join(challenges_triggered)}{RESET}")

                    # Re-run agent with challenge
                    tool_call_records.clear()
                    result = await Runner.run(agent, conversation_history)

                    # Show new response
                    response = result.final_output
                    display.add_conv(f"{LIGHT_BLUE_BOLD}Hasdrubal: {response}{RESET}")
                    display.add_conv("")
                    session_logger.log_assistant(response)
                    conversation_history.append({"role": "assistant", "content": response})

            # Update previous_tool_calls for next turn's visibility hack
            previous_tool_calls = tool_call_records

            # After summary response, exit auto mode (agent gets the last word)
            if is_summary_response:
                display.add_conv(f"{YELLOW_BOLD}[Summary complete - returning to manual mode]{RESET}")
                auto_mode = False
            # In auto mode, inject "yes" as next input (unless TERMINATE or ABORT detected)
            elif auto_mode:
                if "TERMINATE" in response:
                    display.add_conv(f"{YELLOW_BOLD}[TERMINATE detected - soliciting summary]{RESET}")
                    # Inject summary request and continue for one more turn
                    summary_prompt = load_prompt_file("solicit_summary.md")
                    if summary_prompt:
                        pending_initial_prompt = summary_prompt
                        pending_is_auto = False  # This will be the final turn
                        pending_is_summary = True  # Exempt from challenges
                    else:
                        auto_mode = False
                elif "ABORT" in response:
                    display.add_conv(f"{YELLOW_BOLD}[ABORT detected - exiting auto mode]{RESET}")
                    auto_mode = False  # Exit auto mode, return to manual input
                else:
                    pending_initial_prompt = "yes"
                    pending_is_auto = True

        except Exception as e:
            display.add_conv(f"Error: {str(e)}")
            display.add_log(f"ERROR: {str(e)}")
            session_logger.log("error", str(e))
            # Clear previous tool calls on error
            previous_tool_calls = []

        # Restore original call_tool
        mcp_server.call_tool = original_call_tool


async def main():
    """Start split-pane REPL with Hasdrubal."""

    # Parse arguments
    parser = argparse.ArgumentParser(description="Hasdrubal Interactive REPL")
    parser.add_argument("-f", "--file", type=str, help="Path to .md file for initial prompt")
    parser.add_argument("-a", "--auto", action="store_true", help="Automatic mode: auto-reply 'yes' after each agent response")
    args = parser.parse_args()

    # Handle --file option
    initial_prompt = None
    if args.file:
        file_path = Path(args.file)
        if not file_path.exists():
            print(f"Error: File not found: {args.file}")
            return
        if not file_path.suffix == ".md":
            print(f"Error: File must be .md: {args.file}")
            return
        initial_prompt = file_path.read_text()

    # Check API key
    if not os.getenv("OPENAI_API_KEY") or os.getenv("OPENAI_API_KEY") == "your-api-key-here":
        print("Please set OPENAI_API_KEY in config/.env")
        print("Get your key from: https://platform.openai.com/api-keys")
        return

    sessions_dir = project_root / "sessions"

    # Get terminal size
    try:
        term_size = os.get_terminal_size()
        term_height = term_size.lines
        term_width = term_size.columns
    except:
        term_height = 40
        term_width = 120

    # Create display manager (split_ratio=0.25 means logs take top 1/4, conversation takes bottom 3/4)
    display = SplitPaneDisplay(term_height=term_height, term_width=term_width, split_ratio=0.25)

    # Create session logger
    session_logger = SessionLogger(sessions_dir)

    # Configure logging to go to upper pane
    log_handler = LogCapture(display)
    log_handler.setFormatter(logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s"))

    logging.basicConfig(level=logging.INFO, handlers=[log_handler])
    logging.getLogger("mcp").setLevel(logging.INFO)
    logging.getLogger("tools").setLevel(logging.INFO)
    logging.getLogger("wolframclient").setLevel(logging.WARNING)

    # Initialize display
    display.init_display()
    display.add_conv("=" * 60)
    display.add_conv("Hasdrubal - Interactive Hamilcar Assistant")
    display.add_conv("Split Pane Mode: Logs above, conversation below")
    display.add_conv("=" * 60)
    display.add_conv("")
    display.add_conv("Starting MCP server and connecting to Wolfram kernel...")
    display.add_conv("(This may take a few seconds)")
    display.add_conv("")

    # Create MCP server connection
    async with MCPServerStdio(
        name="Hamilcar MCP Server",
        params={
            "command": "python",
            "args": [str(project_root / "hasdrubal_agent" / "mcp_server.py")],
            "env": None
        },
        client_session_timeout_seconds=300  # 5 minutes for complex calculations
    ) as mcp_server:

        # Create agent with MCP server
        agent = create_hasdrubal_agent()
        agent.mcp_servers = [mcp_server]

        display.add_conv("Connected to Hamilcar MCP Server")
        display.add_conv(f"Agent: {agent.name}")
        display.add_conv(f"Model: {agent.model}")
        display.add_conv("")

        display.add_conv("Ready! Type 'quit' or 'exit' to stop.")
        display.add_conv("")

        # Run interactive loop
        await interactive_loop(agent, display, mcp_server, session_logger, initial_prompt, args.auto)

        # Cleanup
        session_logger.close()
        print(MOVE_CURSOR.format(term_height, 1), end='')
        print(f"\n\nGoodbye! Session logged to: {session_logger.log_file}\n")


if __name__ == "__main__":
    asyncio.run(main())
