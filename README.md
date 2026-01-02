# Hasdrubal

A multi-agent system for automating the Dirac-Bergmann algorithm in canonical field theory.

## Overview

Hasdrubal orchestrates the complete Dirac-Bergmann Hamiltonian constraint analysis for free bosonic field theories, from start to finish, without user intervention. The system delegates Poisson bracket computations to [Hamilcar](https://github.com/wbarker/Hamilcar) via a Wolfram kernel, while using large language model inference for high-level algorithmic decisions.

This repository provides the supplementary material for:

> W. Barker, "Orchestration of Dirac-Bergmann Hamiltonian analysis by large language models," *Phys. Rev. D* (2025).

## Citation

```bibtex
@article{Barker:2025hasdrubal,
    author = "Barker, Will",
    title = "{Orchestration of Dirac--Bergmann Hamiltonian analysis by large language models}",
    journal = "Phys. Rev. D",
    year = "2025",
    note = "Supplementary code: https://github.com/wbarker/Hasdrubal"
}
```

## Requirements

- **Python 3.9+**
- **Wolfram Mathematica** (with valid license) or Wolfram Engine
- **OpenAI API key** with access to GPT-5.2
- **Hamilcar** package for xAct/Mathematica ([installation instructions](https://github.com/wbarker/Hamilcar))

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/wbarker/Hasdrubal.git
   cd Hasdrubal
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

   Key dependencies include:
   - `openai-agents` (0.6.3) - OpenAI Agents SDK
   - `wolframclient` (1.4.0) - Wolfram kernel interface
   - `tenacity` (9.1.2) - Retry logic for rate limits
   - `mcp` (1.18.0) - Model Context Protocol

4. Install Hamilcar in Mathematica (see [Hamilcar README](https://github.com/wbarker/Hamilcar)).

## Configuration

Create `config/.env` with your OpenAI API key:

```bash
cp config/.env.example config/.env
# Edit config/.env with your API key
```

The configuration file should contain:

```
OPENAI_API_KEY=sk-proj-your-key-here
```

The API key must have access to GPT-5.2. Configuration in `config/.env` takes precedence over environment variables.

## Usage

Activate the virtual environment and run the REPL:

```bash
source venv/bin/activate
python hasdrubal_repl/hasdrubal_repl.py [OPTIONS]
```

### Options

| Flag | Description |
|------|-------------|
| `-f FILE` | Load initial prompt from a markdown file |
| `-a` | Auto mode: automatically confirms each step |

### Examples

**Interactive mode** (manual confirmation at each step):
```bash
python hasdrubal_repl/hasdrubal_repl.py -f hasdrubal_tests/ProcaTheory.md
```

**Autonomous mode** (full autopilot):
```bash
python hasdrubal_repl/hasdrubal_repl.py -f hasdrubal_tests/ProcaTheory.md -a
```

In autonomous mode, the agent runs until it issues `TERMINATE`, then provides a summary and returns control to the user.

## Reproducing Paper Results

The `sessions/` directory contains the actual session logs from the paper. The `hasdrubal_tests/` directory contains input templates for running new analyses.

### Paper Examples

| Paper Section | Theory | Input File | Paper Session ID |
|--------------|--------|------------|------------------|
| II.C | Massive longitudinal vector | `ProcaTheory.md` | `af268283-...` |
| II.C | Massless longitudinal vector | `MaxwellTheory.md` | `0a434ed6-...` |
| II.C | Massive multi-particle | `CombinedTheory1.md` | `526d8477-...` |
| II.C | Massless multi-gauge | `CombinedTheory2.md` | `75456557-...` |
| II.C | Li-Gao theory | `ZlosnikTheory.md` | `106ddac7-...` |

### Running an Example

To reproduce the Li-Gao theory analysis:

```bash
python hasdrubal_repl/hasdrubal_repl.py -f hasdrubal_tests/ZlosnikTheory.md -a
```

Note that input files use obfuscated variable names (hashes) to prevent the model from recognizing specific theories from its training corpus. Each run generates a new session with fresh obfuscation.

## Session Logs

Sessions are stored as JSONL files in `sessions/`, with each line containing:

```json
{"timestamp": "2025-12-18T00:04:13.424450Z", "type": "user", "content": "..."}
{"timestamp": "2025-12-18T00:04:21.985390Z", "type": "assistant", "content": "..."}
```

The `type` field indicates the message source:
- `user` - User input (including auto-injected prompts and challenges)
- `assistant` - Agent responses
- `error` - Error messages

Session filenames are UUIDs (e.g., `106ddac7-697f-4f87-a871-c98ebdd1829a.jsonl`).

## Architecture

Hasdrubal is a heterogeneous multi-agent system with two components:

1. **LLM Agent** (`hasdrubal_agent/`) - Orchestrates the Dirac-Bergmann algorithm using GPT-5.2 via the OpenAI Agents SDK. The system prompt includes Hamilcar sources and worked examples for in-context learning.

2. **REPL Agent** (`hasdrubal_repl/`) - Regulates the LLM agent via yes/no responses, challenges, and error recovery. Implemented with regex and a fixed decision tree.

The agents communicate via the Model Context Protocol (MCP). The MCP server (`hasdrubal_agent/mcp_server.py`) exposes `tool_WolframScript` for executing arbitrary Wolfram Language code in a persistent Hamilcar kernel.

See Section II of the paper for full architectural details.

## License

MIT License. See [LICENSE](LICENSE) for details.

