#!/bin/bash

# =========================
# Batch runner for all scripts in the current directory
# =========================
# Usage: ./batch-runner.sh true|false
# This script executes all executable files (excluding itself and batch_update_files.sh)
# in the directory, passing the single boolean argument to each script.

set -euo pipefail  # Exit on error, unset variable, or failed pipe

# Metadata header
readonly SCRIPT_NAME=$(basename "$0")  # Get the name of this script
readonly EXCLUDED_SCRIPTS=("batchUpdateFiles.sh")  # List of scripts to skip

# Validate and parse parameter
if [[ $# -ne 1 ]]; then  # Ensure exactly one argument is provided
    echo "Usage: $SCRIPT_NAME true|false"
    exit 1
fi

ENABLE="$1"  # Store the argument

if [[ "$ENABLE" != "true" && "$ENABLE" != "false" ]]; then  # Validate argument value
    echo "Error: Argument must be 'true' or 'false'."
    exit 1
fi

# Ensure we're running in the directory of this script
cd "$(dirname "$0")" || { echo "Failed to change directory."; exit 1; }

# Inform user batch run is starting
echo -e "\n[+] Starting batch run with argument = $ENABLE\n"

# Loop over all executable files in the directory
shopt -s nullglob  # Avoid errors if no files match
for script in ./*; do
    # Skip if not executable
    [[ ! -x "$script" ]] && continue

    # Skip this script
    [[ "$script" == "./$SCRIPT_NAME" ]] && continue

    # Skip other explicitly excluded scripts
    filename=$(basename "$script")
    for excluded in "${EXCLUDED_SCRIPTS[@]}"; do
        if [[ "$filename" == "$excluded" ]]; then
            echo "--> Skipping excluded script: $filename"
            continue 2  # Skip to the next file in the outer loop
        fi
    done

    # Run the script with the argument
    echo "--> Running $filename with argument: $ENABLE"
    if "$script" "$ENABLE"; then
        echo "✔ $filename completed successfully."
    else
        echo "✖ $filename failed."
    fi
    echo
    # Blank line for readability

done

# Inform user batch run is complete
echo "[+] Batch run complete."
