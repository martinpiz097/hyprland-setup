#!/usr/bin/env python3

import sys
import time
import subprocess
from dataclasses import dataclass
from typing import Optional

@dataclass
class WindowInfo:
    workspace: str
    class_name: str

def get_process_stdout(cmd: list[str]) -> str:
    """Execute a command and return its stdout."""
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    except Exception as e:
        print(f"Error executing {cmd}: {e}")
        return ""

def get_windows() -> str:
    """Get list of all windows from hyprctl."""
    return get_process_stdout(["hyprctl", "clients"])

def get_terminal_command() -> Optional[str]:
    """Get the terminal command from config file."""
    try:
        user_home = f"/home/{get_process_stdout(['whoami']).strip()}"
        terminal_script_path = f"{user_home}/.config/ml4w/settings/terminal.sh"
        
        with open(terminal_script_path) as f:
            return f.read().strip()
    except FileNotFoundError:
        print("terminal.sh file not found.")
        return None

class WindowManager:
    def __init__(self, windows_output: str):
        self.windows_output = windows_output

    def find_terminal_window(self, target_workspace: str, terminal_class: str) -> bool:
        """Check if terminal window exists in specified workspace"""
        current_window = WindowInfo("", "")
        found_window = False

        for line in self.windows_output.split("\n"):
            line = line.strip()
            
            if not line:
                current_window = WindowInfo("", "")
                found_window = False
                continue
                
            if "Window" in line:
                found_window = True
                continue
                
            if not found_window:
                continue

            line_split = line.split(": ")
            if len(line_split) < 2:
                continue

            key, value = line_split[0].strip(), line_split[1].strip()
            
            if key == "workspace":
                # Extract workspace number from format like "10 (terminal)" or just "10"
                workspace_parts = value.split(" ")
                current_window.workspace = workspace_parts[0]
            elif key == "class":
                current_window.class_name = value

            # Compare workspace numbers as integers to avoid string comparison issues
            try:
                current_workspace = int(current_window.workspace)
                target_workspace_num = int(target_workspace)
                
                if (current_window.workspace and current_workspace == target_workspace_num and
                    current_window.class_name and terminal_class.lower() in current_window.class_name.lower()):
                    return True
            except ValueError:
                continue

        return False

def main():
    # Get workspace from command line argument
    workspace = str(sys.argv[1]).strip() if len(sys.argv) > 1 else None
    if not workspace:
        print("Error: No workspace specified")
        return

    # Get terminal command
    terminal = get_terminal_command()
    if not terminal:
        return

    # Get current windows and check if terminal exists
    windows = get_windows()
    window_manager = WindowManager(windows)
    
    # Add a small delay to ensure proper window detection
    #time.sleep(0.1)
    
    # Check if terminal window exists in workspace
    terminal_exists = window_manager.find_terminal_window(workspace, terminal)

    move_workspace_process = subprocess.Popen(["hyprctl", "dispatch", "workspace", workspace])
    exit_code = move_workspace_process.wait()
    
    if terminal_exists:
        print(f"✓ Kitty is already running in workspace {workspace}")
    else:
        print(f"! Kitty is not running in workspace {workspace}. Starting Kitty...")
        if exit_code == 0:
            subprocess.Popen([terminal], shell=False)
            print(f"✓ Kitty has been started in workspace {workspace}")

if __name__ == "__main__":
    initial_time = time.time_ns()
    main()
    finish_time = time.time_ns()
    time_diff = (finish_time - initial_time) / pow(10, 6)
    print(f"Execution time in millis: {time_diff}")