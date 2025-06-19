#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Disables the x86 Ctrl-Alt-Delete key sequence to prevent accidental reboots.

.DESCRIPTION
    This script masks the 'ctrl-alt-del.target' systemd unit, disabling the ability
    for a locally logged-in user to reboot the system using the Ctrl-Alt-Delete key
    sequence. This aligns with security hardening requirements to improve system
    availability and avoid unintended shutdowns.

.NOTES
    Author          : Kenneth Clendenin
    AI Contribution : Script generated with assistance from GitHub Copilot and OpenAI ChatGPT.
    Validation      : Final version reviewed, refined, and validated as functional 
                      based on Tenable scan results.
    LinkedIn        : https://www.linkedin.com/in/kenneth-clendenin/
    GitHub          : https://github.com/KennethClendenin
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-211015

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-211015/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to disable the Ctrl-Alt-Delete key sequence (compliant).
    Use $false to enable the Ctrl-Alt-Delete key sequence (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-211015.sh true
------------------------------------------------------------------------------
STIG_HEADER

# Accepts a boolean-style parameter to enable or disable Ctrl-Alt-Delete key sequence
Enable="$1"  # Store the argument (true/false)

# =========================
# Function to set the mask state for ctrl-alt-del.target
# =========================
function Set-CtrlAltDelMaskState() {
    local State="$1"  # true to mask, false to unmask

    if [[ "$State" == "true" ]]; then
        # Mask the ctrl-alt-del.target to disable Ctrl-Alt-Delete
        sudo systemctl mask ctrl-alt-del.target &>/dev/null
        sudo systemctl daemon-reexec &>/dev/null  # Reload systemd
        echo "[ctrl-alt-del.target] Set to masked (compliant: true)"
    elif [[ "$State" == "false" ]]; then
        # Unmask the ctrl-alt-del.target to enable Ctrl-Alt-Delete
        sudo systemctl unmask ctrl-alt-del.target &>/dev/null
        sudo systemctl daemon-reexec &>/dev/null
        echo "[ctrl-alt-del.target] Set to unmasked (compliant: false)"
    else
        echo "[ctrl-alt-del.target] Invalid input. Usage: $0 true|false"
        exit 1
    fi
}

# Call the function with the provided argument
Set-CtrlAltDelMaskState "$Enable"
