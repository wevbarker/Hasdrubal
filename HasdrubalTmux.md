# Hasdrubal Tmux Workflow - Development History

## Overview

This document chronicles the development of the Hasdrubal tmux-based interface, which provides a seamless workflow for interacting with the Hamilcar AI agent through a file-watching system inspired by Vodex.

## Motivation

The goal was to create a Vim-centric workflow where users can:
1. Write prompts in a Vim buffer
2. Save the file (`:w`)
3. Automatically have the prompt sent to the Hasdrubal AI agent
4. See responses in a dedicated REPL pane

This eliminates the need for copy-pasting or context switching between editor and REPL.

## Architecture Evolution

### Initial Approach: Split Panes in Current Window

**Concept**: Split the current tmux pane into three sections:
- Top: Hasdrubal REPL (70% height)
- Middle: File watcher status (2 lines)
- Bottom: Vim editing `.PROMPT.txt`

**Implementation**:
- `AI/hasdrubal` launcher script
- `AI/hasdrubal-watcher` file monitoring script
- Used `tmux split-window` to divide current pane

**Issues Identified**:
1. **No clean exit**: User had to manually close all three panes individually
2. **Messy cleanup**: Panes would persist even after stopping the workflow
3. **Not self-contained**: Modified the user's existing tmux window structure

### Final Approach: Nested Tmux Session

**Concept**: Create an isolated tmux session that contains the 3-pane layout.

**Key Changes**:
- `hasdrubal` creates a new detached session with unique name (e.g., `hasdrubal-12345-1729630000`)
- Uses `tmux switch-client` to move user into the new session
- Watcher script kills entire session on exit via `tmux kill-session`

**Benefits**:
1. **Single-command cleanup**: Ctrl-C in watcher → entire session terminates
2. **Self-contained**: Doesn't affect user's original tmux layout
3. **Clean return**: User automatically returns to original pane after exit
4. **Isolation**: Session can be detached/reattached independently

## Component Details

### 1. Launcher Script (`AI/hasdrubal`)

**Purpose**: Create and configure the 3-pane tmux session.

**Key Features**:
- Validates running inside tmux
- Generates unique session name using PID and timestamp
- Creates `.PROMPT.txt` and `.hasdrubal.log` files
- Builds 3-pane layout with correct split ratios
- Activates Python venv only in REPL pane
- Launches Vim with powerline disabled to avoid module conflicts

**Configuration Options**:
- `HASDRUBAL_TOP_PCT` (default: 70) - REPL pane height percentage
- `HASDRUBAL_MID_LINES` (default: 2) - Watcher pane height in lines
- `-p <percent>` flag to override top pane height

**Pane Layout**:
```
┌─────────────────────────────────────┐
│  REPL (70%)                         │  ← venv activated
│  ┌─────────────────────────────┐    │
│  │ Logs (upper split)          │    │
│  ├─────────────────────────────┤    │
│  │ Conversation (lower split)  │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│  Watcher (2 lines)                  │  ← monitors .PROMPT.txt
├─────────────────────────────────────┤
│  Vim (.PROMPT.txt)                  │  ← no venv, powerline skipped
└─────────────────────────────────────┘
```

### 2. Watcher Script (`AI/hasdrubal-watcher`)

**Purpose**: Monitor `.PROMPT.txt` and send contents to REPL when saved.

**Key Features**:
- Uses `inotifywait` if available, falls back to polling
- Watches for `close_write` events (triggered by `:w` in Vim)
- Sends content via `tmux paste-buffer` to REPL pane
- Automatically presses Enter to submit prompt
- Logs all activity to `.hasdrubal.log`

**Cleanup Behavior**:
- Traps `INT`, `TERM`, and `EXIT` signals
- Detects `HASDRUBAL_SESSION` environment variable
- Executes `tmux kill-session` to close all panes atomically
- Falls back to individual pane cleanup if session name not found

**Environment Variables**:
- `HASDRUBAL_SESSION` - Session name to kill on exit
- `HASDRUBAL_REPL_PANE` - Target pane ID for sending prompts
- `HASDRUBAL_VIM_PANE` - Vim pane ID (for fallback cleanup)
- `HASDRUBAL_PROMPT_FILE` - Path to `.PROMPT.txt`
- `HASDRUBAL_LOG_FILE` - Path to log file

### 3. Split-Pane REPL (`AI/hasdrubal_repl.py`)

**Purpose**: Interactive REPL with dual-pane terminal display.

**Display Architecture**:
- **Upper pane**: Verbose logs (MCP calls, kernel output, timestamps in gray)
- **Lower pane**: Clean conversation (user prompts, agent responses, Wolfram code)
- Uses ANSI escape codes for cursor positioning and screen management
- Automatically wraps long lines in conversation pane (118 char width)

**Key Classes**:
- `SplitPaneDisplay`: Manages dual-pane layout with scrolling buffers
- `LogCapture`: Custom logging handler that routes logs to upper pane
- `ColoredFormatter`: Adds gray ANSI color to timestamps

**Workflow Integration**:
- Accepts input from both keyboard and tmux paste-buffer
- Intercepts MCP tool calls to display Wolfram Language code
- Tracks conversation history across multiple prompts
- Restores cursor to input line after each update

## Technical Challenges Solved

### 1. Vim Powerline Module Error

**Problem**: When venv was activated before running hasdrubal, Vim inherited the venv's Python path and tried to load powerline from it, causing `ModuleNotFoundError`.

**Failed Approaches**:
- Unsetting `VIRTUAL_ENV` in Vim pane
- Using `bash -lc` for clean login shell
- Using `env -i` for clean environment

**Solution**: Launch Vim with `--cmd "let g:powerline_loaded=1"` to skip powerline initialization entirely.

### 2. Cursor Management in Split REPL

**Problem**: Log pane updates would steal cursor focus from input line, disrupting user typing.

**Solution**: Added `restore_cursor_to_input()` method that repositions cursor after every pane update using ANSI escape sequences.

### 3. Text Truncation in Conversation Pane

**Problem**: Long agent responses were cut off at 120 characters per line.

**Solution**: Implemented word-wrapping algorithm in `add_conv()` that splits long text across multiple lines while preserving word boundaries.

### 4. Clean Session Termination

**Problem**: Users had to manually close three panes individually when done.

**Solution**: Nested session approach where watcher script runs `tmux kill-session` on exit, closing all panes atomically and returning user to original location.

## User Experience Flow

1. **Start**: User runs `./AI/hasdrubal` from Hamilcar project root
2. **Session created**: New tmux session spawns with 3 panes
3. **User switches**: Automatically moved into new session
4. **Edit prompt**: Focus starts in Vim, user types prompt
5. **Save**: User presses `:w` in Vim
6. **Auto-send**: Watcher detects save, pastes content to REPL, presses Enter
7. **Agent responds**: Upper pane shows technical logs, lower pane shows conversation
8. **Continue**: User can edit `.PROMPT.txt` again for follow-up questions
9. **Exit**: Ctrl-C in watcher → entire session closes → user back to original pane

## Files Created

```
AI/
├── hasdrubal                    # Launcher (creates tmux session)
├── hasdrubal-watcher           # File monitor (sends prompts to REPL)
├── hasdrubal_repl.py           # Split-pane interactive REPL
├── README_TMUX.md              # User documentation
├── test-vim-launch.sh          # Debug script for Vim issues
└── test-vim-noninteractive.sh  # Non-interactive Vim tests

Generated at runtime:
.PROMPT.txt                     # User's prompt buffer
.hasdrubal.log                  # Watcher activity log
```

## Inspiration: Vodex

The workflow was inspired by the Vodex project (`~/Documents/Vodex`), which provides a similar file-watching interface for Vim integration with AI coding assistants. Key concepts borrowed:

- File watching with `inotifywait`
- Tmux pane orchestration
- Auto-submission via `tmux paste-buffer`
- Three-pane layout (top: AI tool, middle: watcher status, bottom: Vim)

Key differences from Vodex:
- Hasdrubal uses nested sessions instead of pane splitting
- Integrated directly into REPL rather than external adapter pattern
- Split-pane display within REPL for better information density
- Automatic cleanup on exit

## Future Enhancements

Potential improvements identified but not yet implemented:

1. **Streaming responses**: Show agent response as it's generated, not just final output
2. **Conversation persistence**: Save/load conversation history across sessions
3. **Multiple prompt files**: Watch multiple `.PROMPT-*.txt` files for different contexts
4. **Vim integration**: Custom Vim plugin for better syntax highlighting and keybindings
5. **Session management**: List/attach to existing hasdrubal sessions
6. **Configuration file**: `.hasdrubalrc` for persistent settings

## Lessons Learned

1. **Test in target environment**: The powerline issue only appeared when testing with venv activated
2. **Nested sessions > pane splitting**: Better isolation and cleanup semantics
3. **Word wrapping is essential**: Truncation ruins user experience in conversation interfaces
4. **ANSI positioning is powerful**: No need for curses/blessed libraries for simple split layouts
5. **File watching works well**: inotify provides instant response to Vim saves
6. **Tmux is composable**: Paste-buffer + send-keys enables seamless cross-pane communication

## Related Documentation

- `AI/README_TMUX.md` - User-facing quickstart and usage guide
- `CLAUDE.md` - Project-wide instructions including AI agent system
- `AI/AGENT_ANALYSIS.md` - Analysis of agent computation failures (field name collisions)
