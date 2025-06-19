#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Sets the /var/log directory permissions to 0755 (compliant) or more permissive (non-compliant/test).

.DESCRIPTION
    This script configures the permissions on the /var/log directory to control access to system logs.
    Setting permissions to 0755 ensures that only root can write, while others can read and execute.
    This supports log file integrity and limits unauthorized exposure of system and user activity.

.NOTES
    Author          : Kenneth Clendenin
    AI Contribution : Script generated with assistance from GitHub Copilot and OpenAI ChatGPT.
    Validation      : Final version reviewed, refined, and validated as functional based on Tenable scan results.
    LinkedIn        : https://www.linkedin.com/in/kenneth-clendenin/
    GitHub          : https://github.com/KennethClendenin
    Date Created    : 2025-06-18
    Last Modified   : 2025-06-19
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-232025

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-232025/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to set directory to 0755 (compliant).
    Use $false to set directory to 0777 (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-232025.sh true
------------------------------------------------------------------------------
STIG_HEADER

# Accepts a boolean-style parameter
Enable="$1"  # Store the argument (true/false)

# =========================
# Function to set /var/log directory permissions
# =========================
function Set-LogDirPermissions() {
    local State="$1"  # true for 0755, false for 0777
    local Path="/var/log"  # Directory to modify
    local ModeCompliant="0755"  # Compliant permission
    local ModeTest="0777"       # Non-compliant/test permission

    if [[ "$State" == "true" ]]; then
        # Set permissions to 0755 (compliant)
        sudo chmod "$ModeCompliant" "$Path"
        echo "[$Path] Permissions set to $ModeCompliant. (compliant: true)"
    elif [[ "$State" == "false" ]]; then
        # Set permissions to 0777 (non-compliant/test)
        sudo chmod "$ModeTest" "$Path"
        echo "[$Path] Permissions set to $ModeTest. (compliant: false)"
    else
        echo "[$Path] Invalid input. Usage: $0 true|false"
        exit 1
    fi
}

# Call the function with the provided argument
Set-LogDirPermissions "$Enable"
