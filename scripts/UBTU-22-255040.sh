#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Disables remote X11 forwarding for SSH unless explicitly required.

.DESCRIPTION
    This script ensures the SSH server configuration disables X11 forwarding
    by setting 'X11Forwarding no' in the sshd_config file, mitigating the risk of
    exposing the client's X11 display server to attacks via SSH.
    It restarts the sshd service to apply changes immediately.

.NOTES
    Author          : Kenneth Clendenin
    AI Contribution : Script generated with assistance from GitHub Copilot and OpenAI ChatGPT.
    Validation      : Final version reviewed, refined, and validated as functional based on Tenable scan results.
    LinkedIn        : https://www.linkedin.com/in/kenneth-clendenin/
    GitHub          : https://github.com/KennethClendenin
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-19
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-255040

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-255040/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to disable X11 forwarding (compliant).
    Use $false to enable X11 forwarding (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-255040.sh true
------------------------------------------------------------------------------
STIG_HEADER

Enable="$1"  # Store the argument (true/false)
SSHD_CONFIG="/etc/ssh/sshd_config"  # SSH server config file
Backup="/etc/ssh/sshd_config.bak.$(date +%F-%T)"  # Timestamped backup file

# =========================
# Function to set X11Forwarding in sshd_config
# =========================
function Set-X11Forwarding() {
    local State="$1"  # true to disable, false to enable

    # Validate input
    if [[ "$State" != "true" && "$State" != "false" ]]; then
        echo "[X11Forwarding] Invalid input. Usage: $0 true|false"
        exit 1
    fi

    # Backup original config before changes (only if backup doesn't exist)
    if [[ ! -f "$Backup" ]]; then
        sudo cp "$SSHD_CONFIG" "$Backup"
        echo "[X11Forwarding] Backup created at $Backup"
    fi

    # Determine desired value for X11Forwarding
    local DesiredValue="no"
    if [[ "$State" == "false" ]]; then
        DesiredValue="yes"
    fi

    # If line exists, replace; else append
    if sudo grep -qE "^X11Forwarding\s+" "$SSHD_CONFIG"; then
        sudo sed -i "s/^X11Forwarding\s\+.*/X11Forwarding $DesiredValue/" "$SSHD_CONFIG"
        echo "[X11Forwarding] Updated existing directive to '$DesiredValue'"
    else
        echo "X11Forwarding $DesiredValue" | sudo tee -a "$SSHD_CONFIG" >/dev/null
        echo "[X11Forwarding] Added directive with value '$DesiredValue'"
    fi

    # Restart sshd to apply changes
    sudo systemctl restart sshd.service
    if [[ $? -eq 0 ]]; then
        echo "[X11Forwarding] sshd service restarted successfully."
        echo "[X11Forwarding] Set to '$DesiredValue' (compliant: $([[ $State == true ]] && echo true || echo false))"
    else
        echo "[X11Forwarding] Failed to restart sshd service. Please check manually."
        exit 1
    fi
}

# Call the function with the provided argument
Set-X11Forwarding "$Enable"
