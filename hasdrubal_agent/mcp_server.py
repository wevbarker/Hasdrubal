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
        # Generic Wolfram evaluation
        Tool(
            name="tool_GenericWolframScript",
            description="Evaluate arbitrary Wolfram Language code in the Hamilcar kernel",
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
        # Hamilcar: DefCanonicalField
        Tool(
            name="tool_DefCanonicalField",
            description="Define a canonical field and its conjugate momentum",
            inputSchema={
                "type": "object",
                "properties": {
                    "field_expr": {
                        "type": "string",
                        "description": "Field expression, e.g., 'Phi[]' for scalar, 'A[-a]' for vector, 'T[-a,-b]' for tensor"
                    },
                    "symmetry": {
                        "type": "string",
                        "description": "Optional symmetry specification, e.g., 'Antisymmetric[{-a,-b}]'"
                    }
                },
                "required": ["field_expr"]
            }
        ),
        # Hamilcar: PoissonBracket
        Tool(
            name="tool_PoissonBracket",
            description="Compute Poisson bracket between two operators",
            inputSchema={
                "type": "object",
                "properties": {
                    "operator1": {
                        "type": "string",
                        "description": "First operator in Wolfram Language syntax"
                    },
                    "operator2": {
                        "type": "string",
                        "description": "Second operator in Wolfram Language syntax"
                    }
                },
                "required": ["operator1", "operator2"]
            }
        ),
        # Hamilcar: TotalFrom
        Tool(
            name="tool_TotalFrom",
            description="Expand composite quantities to canonical variables (fields, momenta, constants)",
            inputSchema={
                "type": "object",
                "properties": {
                    "expression": {
                        "type": "string",
                        "description": "Expression to expand"
                    }
                },
                "required": ["expression"]
            }
        ),
        # Hamilcar: PrependTotalFrom
        Tool(
            name="tool_PrependTotalFrom",
            description="Register an expansion rule for TotalFrom",
            inputSchema={
                "type": "object",
                "properties": {
                    "rule": {
                        "type": "string",
                        "description": "Rule variable name to register"
                    }
                },
                "required": ["rule"]
            }
        ),
        # Hamilcar: Recanonicalize
        Tool(
            name="tool_Recanonicalize",
            description="Convert expression to canonical form (standard ordering of tensor expressions)",
            inputSchema={
                "type": "object",
                "properties": {
                    "expression": {
                        "type": "string",
                        "description": "Expression to canonicalize"
                    }
                },
                "required": ["expression"]
            }
        ),
        # xAct: DefConstantSymbol
        Tool(
            name="tool_DefConstantSymbol",
            description="Define a constant (coupling) symbol",
            inputSchema={
                "type": "object",
                "properties": {
                    "symbol": {
                        "type": "string",
                        "description": "Symbol name to define as constant"
                    }
                },
                "required": ["symbol"]
            }
        ),
        # xAct: DefTensor
        Tool(
            name="tool_DefTensor",
            description="Define a tensor on the spatial manifold M3",
            inputSchema={
                "type": "object",
                "properties": {
                    "tensor_expr": {
                        "type": "string",
                        "description": "Tensor expression, e.g., 'Constraint[]', 'Multiplier[-a]', 'T[-a,-b]'"
                    },
                    "symmetry": {
                        "type": "string",
                        "description": "Optional symmetry specification, e.g., 'Antisymmetric[{-a,-b}]'"
                    }
                },
                "required": ["tensor_expr"]
            }
        ),
        # xAct: VarD
        Tool(
            name="tool_VarD",
            description="Compute variational derivative of an expression with respect to a tensor",
            inputSchema={
                "type": "object",
                "properties": {
                    "tensor": {
                        "type": "string",
                        "description": "Tensor to vary with respect to, e.g., 'Multiplier[]' or 'SmearingF[-a]'"
                    },
                    "expression": {
                        "type": "string",
                        "description": "Scalar expression to differentiate"
                    }
                },
                "required": ["tensor", "expression"]
            }
        ),
        # xAct: MakeRule
        Tool(
            name="tool_MakeRule",
            description="Create a replacement rule for tensor expressions",
            inputSchema={
                "type": "object",
                "properties": {
                    "lhs": {
                        "type": "string",
                        "description": "Left-hand side (tensor to be expanded), e.g., 'Constraint[]'"
                    },
                    "rhs": {
                        "type": "string",
                        "description": "Right-hand side (expansion expression)"
                    },
                    "rule_name": {
                        "type": "string",
                        "description": "Variable name to store the rule"
                    }
                },
                "required": ["lhs", "rhs", "rule_name"]
            }
        ),
    ]


@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    """Handle tool calls."""
    kernel = ensure_kernel()

    try:
        if name == "tool_GenericWolframScript":
            code = arguments["code"]
            result, messages = kernel.evaluate_with_messages(code)
            response = str(result)
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_DefCanonicalField":
            field_expr = arguments["field_expr"]
            symmetry = arguments.get("symmetry")

            if symmetry:
                code = f"DefCanonicalField[{field_expr}, {symmetry}]"
            else:
                code = f"DefCanonicalField[{field_expr}]"

            result, messages = kernel.evaluate_with_messages(code)
            response = f"Field defined: {result}"
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_PoissonBracket":
            op1 = arguments["operator1"]
            op2 = arguments["operator2"]
            code = f"PoissonBracket[{op1}, {op2}]"

            result, messages = kernel.evaluate_with_messages(code)
            response = str(result)
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_TotalFrom":
            expression = arguments["expression"]
            code = f"TotalFrom[{expression}]"

            result, messages = kernel.evaluate_with_messages(code)
            response = str(result)
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_PrependTotalFrom":
            rule = arguments["rule"]
            code = f"{rule} // PrependTotalFrom"

            result, messages = kernel.evaluate_with_messages(code)
            response = f"Rule registered: {result}"
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_Recanonicalize":
            expression = arguments["expression"]
            code = f"Recanonicalize[{expression}]"

            result, messages = kernel.evaluate_with_messages(code)
            response = str(result)
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_DefConstantSymbol":
            symbol = arguments["symbol"]
            code = f"DefConstantSymbol[{symbol}]"

            result, messages = kernel.evaluate_with_messages(code)
            response = f"Constant defined: {result}"
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_DefTensor":
            tensor_expr = arguments["tensor_expr"]
            symmetry = arguments.get("symmetry")

            if symmetry:
                code = f"DefTensor[{tensor_expr}, M3, {symmetry}]"
            else:
                code = f"DefTensor[{tensor_expr}, M3]"

            result, messages = kernel.evaluate_with_messages(code)
            response = f"Tensor defined: {result}"
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_VarD":
            tensor = arguments["tensor"]
            expression = arguments["expression"]
            code = f"VarD[{tensor}, CD][{expression}]"

            result, messages = kernel.evaluate_with_messages(code)
            response = str(result)
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        elif name == "tool_MakeRule":
            lhs = arguments["lhs"]
            rhs = arguments["rhs"]
            rule_name = arguments["rule_name"]
            code = f"{rule_name} = MakeRule[{{{lhs}, Evaluate[{rhs}]}}, MetricOn->All, ContractMetrics->True]"

            result, messages = kernel.evaluate_with_messages(code)
            response = f"Rule created: {rule_name}"
            if messages:
                response += f"\n\n[Kernel Messages]\n{messages}"
            return [TextContent(type="text", text=response)]

        else:
            return [TextContent(type="text", text=f"Unknown tool: {name}")]

    except Exception as e:
        logger.error(f"Error in {name}: {e}", exc_info=True)
        return [TextContent(type="text", text=f"Error: {str(e)}")]


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
