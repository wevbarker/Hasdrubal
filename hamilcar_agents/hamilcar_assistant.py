"""
Hamilcar Assistant Agent

A general-purpose AI agent for canonical field theory calculations using Hamilcar.
Handles field definitions, Poisson brackets, constraint algebras, and general field theory queries.
"""

from agents import Agent
from typing import List
from pathlib import Path


def load_system_prompt() -> str:
    """Load system prompt from markdown files.

    Loads two files:
    1. system_prompt.md - Hamilcar functionality and examples
    2. interaction_instructions.md - Communication style and interaction guidelines
    """
    base_path = Path(__file__).parent

    # Load Hamilcar functionality
    prompt_path = base_path / "system_prompt.md"
    if not prompt_path.exists():
        raise FileNotFoundError(f"System prompt not found: {prompt_path}")
    system_prompt = prompt_path.read_text()

    # Load interaction instructions
    instructions_path = base_path / "interaction_instructions.md"
    if not instructions_path.exists():
        raise FileNotFoundError(f"Interaction instructions not found: {instructions_path}")
    interaction_instructions = instructions_path.read_text()

    return system_prompt + "\n\n" + interaction_instructions


def create_hamilcar_assistant() -> Agent:
    """
    Create the Hamilcar Assistant agent.

    Returns:
        Configured Agent instance ready to help with field theory
    """
    # Load system prompt from markdown file
    system_prompt = load_system_prompt()

    # Load source context if available
    sources_path = Path(__file__).parent.parent / "hasdrubal_sources.md"

    if sources_path.exists():
        sources_content = sources_path.read_text()
        full_prompt = system_prompt + "\n\n# Source Code Reference\n\nThe following contains the complete source code for Hamilcar and related packages, plus worked examples. Use this for in-context learning.\n\n" + sources_content
    else:
        full_prompt = system_prompt
        print(f"Warning: {sources_path} not found. Run gather_sources.sh to generate it.")

    agent = Agent(
        name="Hasdrubal",
        instructions=full_prompt,
        model="gpt-5.1",  # Requires openai-agents >= 0.6.0
        tools=[],  # MCP tools will be added separately
    )

    return agent


# Agent description for documentation
AGENT_DESCRIPTION = """
Hamilcar Assistant

A general-purpose AI agent for canonical field theory calculations.

Capabilities:
- Natural language → canonical field definitions
- Poisson bracket computations
- Constraint algebra analysis
- ADM gravity, Maxwell theory, custom theories
- Index notation handling
- Physics interpretation

Uses OpenAI GPT-4o with MCP tools for Wolfram/Hamilcar access.
"""
