# Hasdrubal

AI assistant for canonical field theory computations via the Hamilcar Mathematica package.

Named after Hamilcar Barca's son, Hasdrubal provides a natural language interface to complex tensor algebra calculations. Ask questions in plain English and get Wolfram Language computations executed through a persistent kernel connection.

## Quick Start

### Standard REPL

```bash
cd ~/Documents/Hasdrubal
source venv/bin/activate
python hasdrubal_repl.py
```

### Tmux Workflow (Recommended)

```bash
cd ~/Documents/Hasdrubal
source venv/bin/activate
./hasdrubal
```

This creates a 3-pane tmux session:
- **Top**: Split-pane REPL (logs above, conversation below)
- **Middle**: File watcher status
- **Bottom**: Vim editing `.PROMPT.txt`

Write prompts in Vim, save (`:w`), and watch Hasdrubal respond automatically.

Exit with `Ctrl-C` in watcher pane - all panes close automatically.

## Features

### Natural Language Interface

Ask questions about canonical field theory:
```
> Define a scalar field called phi
> What is the Poisson bracket of phi with its conjugate momentum?
> Set $DynamicalMetric to False
> Compute the commutator of the Hamiltonian constraint with itself
```

### Split-Pane Display

- **Upper pane**: Verbose logs (MCP calls, kernel output, timestamps)
- **Lower pane**: Clean conversation (your prompts, agent responses, Wolfram code)

### Vim Integration

Write prompts in your editor, save to send:
1. Edit `.PROMPT.txt` in Vim
2. Save with `:w`
3. Watcher auto-sends to REPL
4. Continue conversation by editing and saving again

### Persistent Kernel

- Maintains Wolfram kernel session across prompts
- Variables persist throughout conversation
- Fast response times (no kernel startup overhead)
- Automatic Hamilcar package loading

## Architecture

```
User Prompt → GPT-4o Agent → MCP Tools → Wolfram Kernel → Hamilcar Package
```

### Components

- **MCP Server** (`mcp_server.py`): Exposes Hamilcar tools via Model Context Protocol
- **Hasdrubal Agent** (`hamilcar_agents/hamilcar_assistant.py`): GPT-4o with field theory knowledge
- **REPL** (`hasdrubal_repl.py`): Interactive split-pane interface
- **Tmux Scripts** (`hasdrubal`, `hasdrubal-watcher`): File-watching workflow

### MCP Tools

- `evaluate_wolfram`: Execute arbitrary Wolfram Language code
- `define_canonical_field`: DefCanonicalField wrapper
- `poisson_bracket`: PoissonBracket computation
- `find_algebra`: Constraint algebra analysis
- `reload_hamilcar`: Reload package sources
- `restart_kernel`: Fresh kernel session

## Requirements

- **Mathematica**: v14.0.0.0 or compatible with Hamilcar package installed
- **Python**: 3.13.7 (virtual environment included)
- **System**: tmux (for workflow mode), inotifywait (optional)

### Python Dependencies

- openai-agents 0.4.0
- wolframclient 1.4.0
- mcp 1.18.0
- pytest 8.4.2

## Configuration

### Environment Variables

Tmux workflow:
- `HASDRUBAL_TOP_PCT` (default: 70) - REPL pane height percentage
- `HASDRUBAL_MID_LINES` (default: 2) - Watcher pane height in lines

Example:
```bash
export HASDRUBAL_TOP_PCT=80
./hasdrubal
```

Or use the `-p` flag:
```bash
./hasdrubal -p 80
```

### API Keys

Set OpenAI API key in `config/.env`:
```
OPENAI_API_KEY=sk-...
```

## Examples

### Programmatic Usage

See `examples/` directory:
- `run_agent.py`: Scripted examples with verification
- `test_persistence.py`: Kernel persistence demonstration
- `test_parallel.py`: Multiple parallel kernels

### Interactive Session

```
> Hi, can you define a scalar field phi for me?

Wolfram Code:
  DefCanonicalField[Phi[], FieldSymbol->"φ", MomentumSymbol->"π"]

Hasdrubal: The scalar field φ and its conjugate momentum π have been
defined successfully. The field has no indices (it's a scalar) and I've
registered it with the canonical field system for Poisson bracket
calculations.

> Great! Now compute the Poisson bracket of phi with pi and store it in
myBracket

Wolfram Code:
  myBracket = PoissonBracket[Phi[], ConjugateMomentumPhi[]]

Hasdrubal: The Poisson bracket has been computed and stored in myBracket.
For a canonical field-momentum pair, this should give you a delta
function times a smearing function.
```

## Testing

### Run Tests

```bash
source venv/bin/activate

# All tests
pytest tests/ -v

# MCP server tests
pytest tests/test_mcp_basic.py -v

# Agent verification tests (golden reference)
pytest tests/test_agent_verification.py -v
```

### Golden Reference Pattern

Tests verify actual kernel state, not just agent responses:

1. Write reference Wolfram script in `tests/references/*.m`
2. Generate expected output: `WolframKernel -script reference.m > reference.expected`
3. Ask agent to perform same computation
4. Compare kernel state to golden reference

This ensures the agent correctly manipulates kernel variables.

## Troubleshooting

### Orphaned Kernels

```bash
killall -9 WolframKernel
```

### Dependency Issues

```bash
source venv/bin/activate
pip install -r requirements.txt
```

### Tmux Session Issues

List active Hasdrubal sessions:
```bash
tmux list-sessions | grep hasdrubal
```

Kill specific session:
```bash
tmux kill-session -t hasdrubal-12345-1234567890
```

### Vim Powerline Errors

The launcher automatically disables powerline to avoid module conflicts. If you see powerline errors, ensure you're using the `./hasdrubal` launcher script, not manually starting vim.

## Documentation

- `README_TMUX.md`: Tmux workflow detailed guide
- `HasdrubalTmux.md`: Complete development history
- `CLAUDE.md`: Claude Code configuration and technical details
- `AGENT_ANALYSIS.md`: Analysis of computation failures and debugging

## Related Projects

- **Hamilcar**: Parent Mathematica package for canonical field theory
  - GitHub: https://github.com/wevbarker/Hamilcar
  - GitLab: https://gitlab.com/wevbarker/Hamilcar

## License

See LICENSE file in repository.

## Contributing

This is a research tool. Contact the maintainer before contributing.
