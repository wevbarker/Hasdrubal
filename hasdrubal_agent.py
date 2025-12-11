"""
Hasdrubal Agent

A general-purpose AI agent for canonical field theory calculations using Hamilcar.
Handles field definitions, Poisson brackets, constraint algebras, and general field theory queries.
"""

from agents import Agent, ModelSettings
from agents.model_settings import Reasoning
from typing import List
from pathlib import Path


def load_system_prompt() -> str:
    """Load system prompt from markdown file."""
    base_path = Path(__file__).parent / "hasdrubal_agent"

    prompt_path = base_path / "system_prompt.md"
    if not prompt_path.exists():
        raise FileNotFoundError(f"System prompt not found: {prompt_path}")

    return prompt_path.read_text()


def create_hasdrubal_agent() -> Agent:
    """
    Create the Hasdrubal agent.

    Returns:
        Configured Agent instance ready to help with field theory
    """
    # Load system prompt from markdown file
    system_prompt = load_system_prompt()

    # Load source context if available (alongside system_prompt.md)
    sources_path = Path(__file__).parent / "hasdrubal_agent" / "hasdrubal_sources.md"

    if sources_path.exists():
        sources_content = sources_path.read_text()
        full_prompt = system_prompt + "\n\n# Source Code Reference\n\nThe following contains the complete source code for Hamilcar and related packages, plus worked examples. Use this for in-context learning.\n\n" + sources_content
    else:
        full_prompt = system_prompt
        print(f"Warning: {sources_path} not found. Run gather_sources.sh to generate it.")

    agent = Agent(
        name="Hasdrubal",
        instructions=full_prompt,
        model="gpt-5.2",
        model_settings=ModelSettings(
            reasoning=Reasoning(effort="medium"),
        ),
        tools=[],  # MCP tools will be added separately
    )

    return agent


# Agent description for documentation
AGENT_DESCRIPTION = """
Hasdrubal Agent

A general-purpose AI agent for canonical field theory calculations.

Capabilities:
- Natural language -> canonical field definitions
- Poisson bracket computations
- Constraint algebra analysis
- ADM gravity, Maxwell theory, custom theories
- Index notation handling
- Physics interpretation

Uses OpenAI GPT-5.2 with MCP tools for Wolfram/Hamilcar access.
"""
