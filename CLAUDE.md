# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Hasdrubal is an AI assistant for canonical field theory computations. It provides a natural language interface to the Hamilcar Mathematica package via the OpenAI Agents SDK and Model Context Protocol (MCP). Named after Hamilcar's son, Hasdrubal enables physicists to perform complex tensor calculations through conversational prompts.

## Architecture

```
User Natural Language → Hasdrubal (GPT-4o) → MCP Tools → Wolfram Kernel → Hamilcar
```

The system consists of three layers:
1. **Interface Layer**: Interactive REPL with split-pane display and tmux-based Vim workflow
2. **Agent Layer**: GPT-4o agent with Hamilcar domain knowledge
3. **Computation Layer**: MCP server managing persistent Wolfram kernel with Hamilcar package

## Key Components

### MCP Server (`mcp_server.py`)

Exposes Hamilcar functionality via Model Context Protocol:

**Tools**:
- `evaluate_wolfram`: Execute arbitrary Wolfram Language code
- `define_canonical_field`: DefCanonicalField wrapper
- `poisson_bracket`: PoissonBracket computation
- `find_algebra`: Constraint algebra analysis
- `reload_hamilcar`: Reload package sources
- `restart_kernel`: Fresh kernel session

**Features**:
- Maintains persistent Wolfram kernel with Hamilcar loaded
- Handles kernel initialization and error recovery
- Provides tool-specific error handling and logging

### Hasdrubal Agent (`hamilcar_agents/hamilcar_assistant.py`)

GPT-4o agent with specialized knowledge:

**Capabilities**:
- Understands natural language field theory requests
- Writes Wolfram Language code for assignments and computations
- Handles tensor index notation correctly
- Knows Hamilcar API and conventions

**System Prompt Includes**:
- Complete Hamilcar API knowledge
- ADM gravity and Maxwell theory examples
- Wolfram Language assignment patterns
- Index notation handling

### Interactive REPL (`hasdrubal_repl.py`)

Split-pane terminal interface:

**Upper Pane** (65% height):
- Verbose logs (MCP calls, kernel output)
- Timestamped activity in gray
- Technical debugging information

**Lower Pane** (35% height):
- User prompts
- Agent responses
- Wolfram Language code summary

**Features**:
- ANSI-based cursor management
- Word-wrapping for long responses
- Automatic scrolling buffers
- Clean conversation view

### Tmux Workflow (`hasdrubal`, `hasdrubal-watcher`)

File-watching workflow inspired by Vodex:

**Layout** (nested tmux session):
```
┌─────────────────────────────────────┐
│  REPL (70%)                         │
│  ┌─────────────────────────────┐    │
│  │ Logs (upper split)          │    │
│  ├─────────────────────────────┤    │
│  │ Conversation (lower split)  │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│  Watcher (2 lines)                  │
├─────────────────────────────────────┤
│  Vim (.PROMPT.txt)                  │
└─────────────────────────────────────┘
```

**Workflow**:
1. User writes prompt in Vim (bottom pane)
2. Saves file (`:w`)
3. Watcher detects save via inotifywait
4. Content sent to REPL via tmux paste-buffer
5. Agent responds in upper pane
6. Conversation continues

**Exit Behavior**:
- Ctrl-C in watcher → kills entire nested session
- Automatically returns to original tmux location
- Self-contained: doesn't affect user's tmux layout

## Usage

### Standard REPL

```bash
cd ~/Documents/Hasdrubal
source venv/bin/activate
python hasdrubal_repl.py
```

### Tmux Workflow

```bash
cd ~/Documents/Hasdrubal
source venv/bin/activate
./hasdrubal
```

Configuration via environment variables:
- `HASDRUBAL_TOP_PCT` (default: 70) - REPL pane height percentage
- `HASDRUBAL_MID_LINES` (default: 2) - Watcher pane height

Or use `-p` flag:
```bash
./hasdrubal -p 80
```

### Example Queries

- "Define a scalar field called psi"
- "Compute the Poisson bracket of psi with its conjugate momentum and store it in myBracket"
- "Set $DynamicalMetric to False"
- "Define a vector field A for electromagnetism"

## Testing

### Test Structure

Golden reference pattern:
1. Write reference WL script in `tests/references/*.m`
2. Generate expected output: `WolframKernel -script reference.m > reference.expected`
3. Ask agent to perform same computation
4. Verify kernel state matches golden output

Tests verify:
- Agent calls correct MCP tools
- Kernel state changes as expected
- Results stored in variables correctly
- Not just what agent says it did, but what actually happened

### Running Tests

```bash
source venv/bin/activate

# MCP server tests (7/7 passing)
pytest tests/test_mcp_basic.py -v

# Agent verification tests (golden reference pattern)
pytest tests/test_agent_verification.py -v

# Single test
pytest tests/test_mcp_basic.py::test_basic_evaluation -v
```

Test execution time:
- Single test: ~5-7 seconds (fresh kernel per test)
- Full MCP suite: ~48 seconds
- Agent verification: ~20-30 seconds

Troubleshooting:
```bash
# Kill orphaned kernels
killall -9 WolframKernel

# Reinstall dependencies
pip install -r requirements.txt
```

## Dependencies

- **Python**: 3.13.7 with venv at `./venv`
- **AI Libraries**:
  - openai-agents 0.4.0
  - mcp 1.18.0
- **Wolfram Interface**:
  - wolframclient 1.4.0
- **Testing**:
  - pytest 8.4.2
- **System Requirements**:
  - Mathematica with Hamilcar package installed
  - tmux (for workflow mode)
  - inotifywait (optional, for instant file watching)

## File Structure

```
hasdrubal                           # Tmux launcher
hasdrubal-watcher                  # File watcher for Vim integration
hasdrubal_repl.py                  # Split-pane interactive REPL
mcp_server.py                      # MCP server exposing Hamilcar tools
requirements.txt                   # Python dependencies
venv/                              # Python virtual environment

hamilcar_agents/
├── __init__.py
└── hamilcar_assistant.py          # Agent definition

tools/
├── __init__.py
└── wolfram_kernel.py              # Kernel manager

tests/
├── test_mcp_basic.py              # MCP server tests
├── test_agent_verification.py    # Agent golden reference tests
└── references/                    # Reference Wolfram scripts
    ├── scalar_field.m
    ├── scalar_field.expected
    └── ...

examples/
├── run_agent.py                   # Scripted examples
├── test_persistence.py            # Kernel persistence demo
└── test_parallel.py               # Parallel kernels demo

config/
└── .env                           # API keys (gitignored)

sessions/                          # Session logs (gitignored)
```

## Development Workflow

### Testing Locally

Start venv:
```bash
source venv/bin/activate
```

Run REPL:
```bash
python hasdrubal_repl.py
```

Run tests:
```bash
pytest tests/ -v
```

### Adding New MCP Tools

1. Add tool definition in `mcp_server.py`:
   - `@app.list_tools()`: Register tool schema
   - `@app.call_tool()`: Implement tool handler
2. Update agent system prompt if needed in `hamilcar_agents/hamilcar_assistant.py`
3. Add golden reference test in `tests/test_agent_verification.py`
4. Create reference script in `tests/references/`

### Debugging

Enable verbose logging:
```python
logging.basicConfig(level=logging.DEBUG)
```

Check kernel status:
```bash
ps aux | grep WolframKernel
```

View session logs:
```bash
cat sessions/*.log
```

## Technical Challenges Solved

### Vim Powerline Module Error

**Problem**: When venv active, Vim inherited venv Python path and tried to load powerline, causing `ModuleNotFoundError`.

**Solution**: Launch Vim with `--cmd "let g:powerline_loaded=1"` to skip powerline initialization.

### Cursor Management in Split REPL

**Problem**: Log pane updates stole cursor focus from input line.

**Solution**: Added `restore_cursor_to_input()` method using ANSI escape sequences.

### Text Truncation

**Problem**: Long agent responses cut off at 120 characters per line.

**Solution**: Word-wrapping algorithm in `add_conv()` that splits text across lines while preserving word boundaries.

### Clean Session Termination

**Problem**: Users had to manually close three panes individually.

**Solution**: Nested tmux session approach where watcher runs `tmux kill-session` on exit, closing all panes atomically.

## Code Style and Professional Standards

NEVER use emojis in code, comments, documentation, output, or user-facing text. This is a professional codebase.

## Related Documentation

- `README_TMUX.md` - Tmux workflow quickstart guide
- `HasdrubalTmux.md` - Complete development history of tmux interface
- `AGENT_ANALYSIS.md` - Analysis of agent computation failures (field name collisions)
- Hamilcar CLAUDE.md - Parent package documentation

## Important Reminders

- Always conclude `.m` scripts with `Quit[];`
- Never code in non-ASCII characters
- Use `Comment@"<content>"` for xPlain documentation when loaded
- Be proactive asking physics questions using appropriate AI tools
