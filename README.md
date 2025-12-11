<img src="logos/GitHubLogo.png" width="1000">

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

### Wrapper Script

```bash
./hasdrubal_repl.sh
```

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

### Persistent Kernel

- Maintains Wolfram kernel session across prompts
- Variables persist throughout conversation
- Fast response times (no kernel startup overhead)
- Automatic Hamilcar package loading

## Architecture

```
User Prompt → GPT-5.1 Agent → MCP Tools → Wolfram Kernel → Hamilcar Package
```

### Components

- **MCP Server** (`mcp_server.py`): Exposes Hamilcar tools via Model Context Protocol
- **Hasdrubal Agent** (`hamilcar_agents/hamilcar_assistant.py`): GPT-5.1 with field theory knowledge
- **REPL** (`hasdrubal_repl.py`): Interactive split-pane interface

### MCP Tools

- `evaluate_wolfram`: Execute arbitrary Wolfram Language code
- `define_canonical_field`: DefCanonicalField wrapper
- `poisson_bracket`: PoissonBracket computation

## Requirements

- **Mathematica**: v14.0.0.0 or compatible with Hamilcar package installed
- **Python**: 3.13.7 (virtual environment included)
- **System**: Linux

### Python Dependencies

- openai-agents 0.4.0
- wolframclient 1.4.0
- mcp 1.18.0
- pytest 8.4.2

## Configuration

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

## Related Projects

- **Hamilcar**: Parent Mathematica package for canonical field theory
  - GitHub: https://github.com/wevbarker/Hamilcar
  - GitLab: https://gitlab.com/wevbarker/Hamilcar

## License

See LICENSE file in repository.

## Contributing

This is a research tool. Contact the maintainer before contributing.
