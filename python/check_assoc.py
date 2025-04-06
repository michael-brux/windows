#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Checks Windows file association (assoc) and file type execution (ftype)
for a given file extension using Python's subprocess module.

Uses shell=True as a workaround for systems where 'assoc'/'ftype'
run in cmd.exe but are not found via standard PATH lookup by 'where'
or subprocess(shell=False).

Requires: Python 3.x
Platform: Windows


"""

import subprocess
import argparse
import sys
import locale
import os
import shlex # Used for quoting arguments safely with shell=True

def get_windows_encoding():
    """
    Gets the preferred encoding for the console on Windows.
    Tries locale.getpreferredencoding first, falls back to utf-8.
    """
    try:
        encoding = locale.getpreferredencoding(False)
        if encoding and isinstance(encoding, str) and len(encoding) > 2:
             "test".encode(encoding).decode(encoding)
             return encoding
        else:
             print("Warning: Could not determine reliable console encoding, falling back to utf-8.", file=sys.stderr)
             return 'utf-8'
    except Exception as e:
        print(f"Warning: Error getting preferred encoding ({e}), falling back to utf-8.", file=sys.stderr)
        return 'utf-8'

def run_command(command_list, encoding):
    """
    Helper function to run a command using subprocess and capture output.
    Uses shell=True to leverage cmd.exe's ability to find commands like assoc/ftype
    when standard PATH lookup fails.

    Args:
        command_list (list): The command and its arguments as a list.
                             The list will be joined into a string for shell=True.
        encoding (str): The encoding to use for decoding output.

    Returns:
        subprocess.CompletedProcess: The result object from subprocess.run.
                                      Returns None if an error occurs during execution setup.
    """
    if not command_list:
        return None

    # --- Using shell=True ---
    # Quote arguments to prevent shell injection issues, although assoc/ftype args are usually simple.
    # shlex.join is preferred in Python 3.8+ for creating shell-safe command strings.
    # If using older Python, manual joining with quoting is needed (more complex).
    # For assoc/ftype, the arguments (extension, filetype) are less risky,
    # but using shlex.join or similar quoting is best practice.
    # Simple joining might be sufficient here IF WE TRUST the inputs.
    # Let's use simple join first and see if it works, add shlex if needed.
    # command_string = ' '.join(command_list) # Simplest approach
    try:
        # For better safety with shell=True, especially if args could have spaces/special chars:
        # command_string = shlex.join(command_list) # Use this in Python 3.8+
        # Manual basic quoting for broader compatibility (less robust than shlex):
        command_string = command_list[0] + ' ' + ' '.join(shlex.quote(arg) for arg in command_list[1:])

        print(f"Running command via shell: {command_string}") # Show the command string being used

        result = subprocess.run(
            command_string, # Pass command as a string
            shell=True,     # Use the system shell (cmd.exe)
            capture_output=True,
            text=True,      # Try auto-decode first
            # encoding=encoding, # Specify encoding if text=True unreliable
            check=False,    # Don't raise exception on non-zero exit
            env=os.environ
        )

        # Fallback decoding attempt if text=True failed
        if result.stdout is None and result.stderr is None:
             result = subprocess.run(
                 command_string,
                 shell=True,
                 capture_output=True,
                 encoding=encoding, # Use explicit encoding
                 check=False,
                 env=os.environ
             )
        return result
    # FileNotFoundError should NOT happen with shell=True unless cmd.exe itself is missing
    except Exception as e:
        print(f"An unexpected error occurred while running '{command_string}': {e}", file=sys.stderr)
        return None


def check_association(extension):
    """
    Runs 'assoc' and 'ftype' to find the file type and execution command
    for a given extension.

    Args:
        extension (str): The file extension to check (e.g., '.py', '.txt').

    Returns:
        tuple: (file_type, command_string) or (None, None) if not found
               or an error occurred. Prints findings or errors.
    """
    if not extension:
        print("Error: No extension provided.", file=sys.stderr)
        return None, None

    if not extension.startswith('.'):
        extension = '.' + extension

    print(f"--- Checking association for: {extension} ---")

    file_type = None
    command_string = None

    # Determine encoding once
    encoding = get_windows_encoding()
    print(f"(Using console encoding: {encoding})")

    # --- Step 1: Run assoc ---
    assoc_cmd = ['assoc', extension]
    # No change needed here, run_command handles the shell=True logic
    assoc_result = run_command(assoc_cmd, encoding)

    if assoc_result is None: # Error during setup/execution
        return None, None

    # Handle assoc command failure or no association found
    # (Check returncode AND stdout as assoc might return 0 but print error)
    if assoc_result.returncode != 0 or "File association not found" in assoc_result.stdout:
        error_output = assoc_result.stdout.strip() or assoc_result.stderr.strip()
        if "File association not found" in error_output or not error_output:
             print(f"No file association found for '{extension}'.")
        else:
             # Report actual error if assoc returned non-zero and didn't say "not found"
             print(f"Error running assoc (Return Code: {assoc_result.returncode}): {error_output}")
        return None, None # No association, so no point checking ftype

    # Parse successful assoc output
    assoc_output = assoc_result.stdout.strip()
    if '=' not in assoc_output:
        # Added check for empty output which might indicate success but no association
        if not assoc_output:
             print(f"No file association found for '{extension}' (assoc returned empty).")
             return None, None
        print(f"Unexpected output format from assoc: {assoc_output}")
        return None, None

    # Output format: .ext=FileType
    parts = assoc_output.split('=', 1)
    if len(parts) == 2 and parts[0].lower() == extension.lower():
        file_type = parts[1]
        print(f"Extension '{extension}' is associated with File Type: '{file_type}'")
    else:
        print(f"Could not parse assoc output or extension mismatch: {assoc_output}")
        return None, None # Parsing failed

    # --- Step 2: Run ftype (only if file_type was found) ---
    if file_type:
        ftype_cmd = ['ftype', file_type]
        # No change needed here, run_command handles the shell=True logic
        ftype_result = run_command(ftype_cmd, encoding)

        if ftype_result is None: # Error during setup/execution
             # Still return the file_type found by assoc
            return file_type, None

        # Handle ftype command failure or no type definition found
        if ftype_result.returncode != 0 or "not found" in ftype_result.stdout.strip().lower():
             error_output = ftype_result.stdout.strip() or ftype_result.stderr.strip()
             # Check common "not found" message case-insensitively
             if "file type" in error_output.lower() and "not found" in error_output.lower() or not error_output:
                 print(f"No execution command (ftype) found for File Type '{file_type}'.")
             else:
                 print(f"Error running ftype (Return Code: {ftype_result.returncode}): {error_output}")
             # Return the file_type even if ftype fails, as assoc succeeded
             return file_type, None # No command string found

        # Parse successful ftype output
        ftype_output = ftype_result.stdout.strip()
        # Output format: FileType=CommandString
        if '=' not in ftype_output:
             # Added check for empty output
             if not ftype_output:
                 print(f"No execution command (ftype) found for File Type '{file_type}' (ftype returned empty).")
                 return file_type, None
             print(f"Unexpected output format from ftype: {ftype_output}")
             # Still return file_type
             return file_type, None

        parts = ftype_output.split('=', 1)
        # Check if the part before '=' looks reasonably like the file_type (case-insensitive)
        if len(parts) == 2 and parts[0].strip().lower() == file_type.lower():
            command_string = parts[1]
            print(f"File Type '{file_type}' executes with command:")
            print(f"  {command_string}")
        else:
            # Handle cases where ftype might return something unexpected
            command_string = ftype_output # Store the raw output as command
            print(f"Execution command (ftype) found for '{file_type}' (output parsing might be imperfect):")
            print(f"  {command_string}")


    print("\n--- Check complete ---")
    return file_type, command_string

if __name__ == "__main__":
    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(
        description="Check Windows file association (assoc) and execution command (ftype). Uses shell=True.",
        epilog=f"Example: python {os.path.basename(__file__)} .py"
    )
    parser.add_argument(
        "extension",
        nargs='?', # Make argument optional
        default=None,
        help="The file extension to check (e.g., '.py', 'txt'). Leading dot is optional."
    )

    args = parser.parse_args()
    target_extension = args.extension

    # If no argument was provided, prompt the user
    if target_extension is None:
        try:
            target_extension = input("Enter the file extension to check (e.g., .py, txt): ")
            if not target_extension:
                 print("No extension entered. Exiting.")
                 sys.exit(1)
        except EOFError: # Handle environments where input is not possible
             parser.print_help(sys.stderr)
             sys.exit(1)


    # Run the main check function
    check_association(target_extension)
