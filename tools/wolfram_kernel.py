"""
Wolfram Kernel Manager

Maintains a persistent Wolfram kernel session for Hamilcar computations.
"""

import logging
import tempfile
import os
from typing import Optional, Tuple
from wolframclient.evaluation import WolframLanguageSession
from wolframclient.language import wl, wlexpr

logger = logging.getLogger(__name__)


class WolframKernelManager:
    """Manages a persistent Wolfram kernel session."""

    def __init__(self, kernel_path: Optional[str] = None):
        """
        Initialize the Wolfram kernel manager.

        Args:
            kernel_path: Path to Wolfram kernel executable.
                        If None, uses default system path.
        """
        self.kernel_path = kernel_path or "wolframkernel"
        self.session: Optional[WolframLanguageSession] = None
        self._hamilcar_loaded = False
        self._messages_file: Optional[str] = None
        self._messages_position: int = 0

    def start(self) -> None:
        """Start the Wolfram kernel session."""
        if self.session is not None:
            logger.warning("Kernel already running")
            return

        logger.info(f"Starting Wolfram kernel: {self.kernel_path}")
        self.session = WolframLanguageSession(self.kernel_path)
        logger.info("Wolfram kernel started successfully")

        # Set up message logging to file
        self._setup_message_logging()

    def _setup_message_logging(self) -> None:
        """Redirect kernel $Messages to a temp file for capture."""
        # Create temp file for messages
        fd, self._messages_file = tempfile.mkstemp(suffix=".txt", prefix="wl_messages_")
        os.close(fd)
        self._messages_position = 0

        # Redirect $Messages in kernel
        escaped_path = self._messages_file.replace("\\", "\\\\")
        code = f'$Messages = {{OpenWrite["{escaped_path}"]}}'
        self.session.evaluate(wlexpr(code))
        logger.info(f"Kernel messages redirected to: {self._messages_file}")

    def _read_new_messages(self) -> str:
        """Read any new messages since last check."""
        if not self._messages_file or not os.path.exists(self._messages_file):
            return ""

        # Flush kernel message stream
        try:
            self.session.evaluate(wlexpr('Scan[Flush, $Messages]'))
        except Exception:
            pass

        # Read new content
        with open(self._messages_file, "r") as f:
            f.seek(self._messages_position)
            new_content = f.read()
            self._messages_position = f.tell()

        return new_content.strip()

    def stop(self) -> None:
        """Stop the Wolfram kernel session."""
        if self.session is None:
            logger.warning("No kernel to stop")
            return

        logger.info("Stopping Wolfram kernel")
        self.session.terminate()
        self.session = None
        self._hamilcar_loaded = False

        # Clean up messages file
        if self._messages_file and os.path.exists(self._messages_file):
            try:
                os.remove(self._messages_file)
            except Exception:
                pass
            self._messages_file = None
        self._messages_position = 0

        logger.info("Wolfram kernel stopped")

    def restart(self) -> None:
        """Restart the Wolfram kernel session."""
        logger.info("Restarting Wolfram kernel")
        self.stop()
        self.start()
        if self._hamilcar_loaded:
            self.load_hamilcar()

    def load_hamilcar(self) -> bool:
        """
        Load the Hamilcar package into the kernel.

        Returns:
            True if successful, False otherwise.
        """
        if self.session is None:
            raise RuntimeError("Kernel not started")

        try:
            logger.info("Loading Hamilcar package")
            result = self.session.evaluate(wlexpr('<<xAct`Hamilcar`'))
            # Disable message suppression after repeated warnings
            self.session.evaluate(wlexpr('Off[General::stop]'))
            self._hamilcar_loaded = True
            logger.info("Hamilcar package loaded successfully")
            return True
        except Exception as e:
            logger.error(f"Failed to load Hamilcar: {e}")
            return False

    def evaluate(self, code: str, load_hamilcar: bool = True) -> any:
        """
        Evaluate Wolfram Language code.

        Args:
            code: Wolfram Language code to evaluate
            load_hamilcar: If True, ensure Hamilcar is loaded first

        Returns:
            Result of the evaluation
        """
        if self.session is None:
            raise RuntimeError("Kernel not started. Call start() first.")

        if load_hamilcar and not self._hamilcar_loaded:
            self.load_hamilcar()

        logger.debug(f"Evaluating: {code}")
        result = self.session.evaluate(wlexpr(code))
        logger.debug(f"Result: {result}")
        return result

    def evaluate_with_messages(self, code: str, load_hamilcar: bool = True) -> Tuple[any, str]:
        """
        Evaluate Wolfram Language code and capture any messages.

        Args:
            code: Wolfram Language code to evaluate
            load_hamilcar: If True, ensure Hamilcar is loaded first

        Returns:
            Tuple of (result, messages_string)
        """
        if self.session is None:
            raise RuntimeError("Kernel not started. Call start() first.")

        if load_hamilcar and not self._hamilcar_loaded:
            self.load_hamilcar()

        # Clear any pending messages before evaluation
        _ = self._read_new_messages()

        logger.debug(f"Evaluating: {code}")
        result = self.session.evaluate(wlexpr(code))
        logger.debug(f"Result: {result}")

        # Capture messages generated during this evaluation
        messages = self._read_new_messages()
        if messages:
            logger.debug(f"Messages: {messages}")

        return result, messages

    def evaluate_function(self, func_name: str, *args, load_hamilcar: bool = True) -> any:
        """
        Evaluate a Hamilcar function with arguments.

        Args:
            func_name: Name of the Hamilcar function
            *args: Arguments to pass to the function
            load_hamilcar: If True, ensure Hamilcar is loaded first

        Returns:
            Result of the function evaluation
        """
        if self.session is None:
            raise RuntimeError("Kernel not started. Call start() first.")

        if load_hamilcar and not self._hamilcar_loaded:
            self.load_hamilcar()

        logger.debug(f"Calling {func_name} with args: {args}")
        # Build function call using wolframclient's expression builder
        func = getattr(wl, func_name)
        result = self.session.evaluate(func(*args))
        logger.debug(f"Result: {result}")
        return result

    def is_running(self) -> bool:
        """Check if kernel is running."""
        return self.session is not None

    def __enter__(self):
        """Context manager entry."""
        self.start()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit."""
        self.stop()
