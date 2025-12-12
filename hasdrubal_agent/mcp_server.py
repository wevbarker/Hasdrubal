"""
Hamilcar MCP Server

Model Context Protocol server providing AI agents with access to
Hamilcar canonical field theory computations.
"""

import logging
import os
from typing import Any
from dotenv import load_dotenv

from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

from tools.wolfram_kernel import WolframKernelManager

# Load environment variables
load_dotenv("config/.env")

# Configure logging with colored timestamps
GRAY = '\033[90m'
RESET = '\033[0m'

class ColoredFormatter(logging.Formatter):
    def format(self, record):
        # Color the timestamp part gray
        original = super().format(record)
        # Split at first space after timestamp (format: "YYYY-MM-DD HH:MM:SS,mmm - ...")
        parts = original.split(' - ', 1)
        if len(parts) == 2:
            timestamp = parts[0]
            rest = parts[1]
            return f"{GRAY}{timestamp}{RESET} - {rest}"
        return original

handler = logging.StreamHandler()
handler.setFormatter(ColoredFormatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s"))
logging.basicConfig(
    level=os.getenv("AGENT_LOG_LEVEL", "INFO"),
    handlers=[handler]
)
logger = logging.getLogger(__name__)

# Initialize MCP server
app = Server("hamilcar-mcp")

# Global kernel manager (initialized on first tool call)
kernel_manager: WolframKernelManager = None


def ensure_kernel() -> WolframKernelManager:
    """Ensure Wolfram kernel is running."""
    global kernel_manager
    if kernel_manager is None:
        kernel_path = os.getenv("MATHEMATICA_KERNEL_PATH", "wolframkernel")
        kernel_manager = WolframKernelManager(kernel_path)
        kernel_manager.start()
        kernel_manager.load_hamilcar()
    return kernel_manager


@app.list_tools()
async def list_tools() -> list[Tool]:
    """List available Hamilcar tools."""
    return [
        Tool(
            name="tool_WolframScript",
            description="Evaluate Wolfram Language code in the Hamilcar kernel",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "Wolfram Language code to evaluate"
                    }
                },
                "required": ["code"]
            }
        ),
    ]


def format_response(code: str, result: str, messages: str = None) -> str:
    """Format tool response with executed code prefix."""
    response = f"[Executed]\n{code}\n[/Executed]\n\n{result}"
    if messages:
        response += f"\n\n[Kernel Messages]\n{messages}"
    return response


@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    """Handle tool calls."""
    kernel = ensure_kernel()

    try:
        if name == "tool_WolframScript":
            code = arguments["code"]
            result, messages = kernel.evaluate_with_messages(code)
            response = format_response(code, str(result), messages)
            return [TextContent(type="text", text=response)]

        else:
            return [TextContent(type="text", text=f"[Executed]\n(unknown tool)\n[/Executed]\n\nUnknown tool: {name}")]

    except Exception as e:
        logger.error(f"Error in {name}: {e}", exc_info=True)
        if 'code' in locals():
            return [TextContent(type="text", text=f"[Executed]\n{code}\n[/Executed]\n\nError: {str(e)}")]
        else:
            return [TextContent(type="text", text=f"[Executed]\n(error before code construction)\n[/Executed]\n\nError: {str(e)}")]


async def main():
    """Run the MCP server."""
    logger.info("Starting Hamilcar MCP Server")

    async with stdio_server() as (read_stream, write_stream):
        await app.run(
            read_stream,
            write_stream,
            app.create_initialization_options()
        )

    # Cleanup
    if kernel_manager is not None:
        kernel_manager.stop()
    logger.info("Hamilcar MCP Server stopped")


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
