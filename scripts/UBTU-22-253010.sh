#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Ensures TCP syncookies are enabled to help prevent SYN flood attacks.

.DESCRIPTION
    TCP syncookies are a security feature that helps protect against SYN flood
    denial-of-service (DoS) attacks by ensuring that connection state is not
    stored until the final ACK of the handshake is received. This script ensures
    that net.ipv4.tcp_syncookies is set to 1 persistently and at runtime.

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
    STIG-ID         : UBTU-22-253010

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-253010/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to enable TCP syncookies (compliant).
    Use $false to disable TCP syncookies (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-253010.sh true
------------------------------------------------------------------------------
STIG_HEADER

Enable="$1"  # Store the argument (true/false)

# =========================
# Function to configure TCP syncookies
# =========================
function Configure-TCPSyncookies() {
    local State="$1"  # true to enable, false to disable

    if [[ "$State" == "true" ]]; then
        # Apply runtime setting
        sudo sysctl -w net.ipv4.tcp_syncookies=1 >/dev/null 2>&1

        # Ensure persistent setting in /etc/sysctl.conf
        sudo sed -i '/^net\.ipv4\.tcp_syncookies\s*=\s*/d' /etc/sysctl.conf
        echo "net.ipv4.tcp_syncookies = 1" | sudo tee -a /etc/sysctl.conf >/dev/null

        # Reload sysctl settings
        sudo sysctl --system >/dev/null 2>&1

        # Validate current state
        current=$(sysctl -n net.ipv4.tcp_syncookies)
        if [[ "$current" == "1" ]]; then
            echo "[tcp_syncookies] Configuration applied successfully. (compliant: true)"
        else
            echo "[tcp_syncookies] Failed to apply configuration. (compliant: false)"
        fi

    elif [[ "$State" == "false" ]]; then
        # Disable syncookies at runtime and persistently
        sudo sysctl -w net.ipv4.tcp_syncookies=0 >/dev/null 2>&1
        sudo sed -i '/^net\.ipv4\.tcp_syncookies\s*=\s*/d' /etc/sysctl.conf
        echo "net.ipv4.tcp_syncookies = 0" | sudo tee -a /etc/sysctl.conf >/dev/null
        sudo sysctl --system >/dev/null 2>&1

        current=$(sysctl -n net.ipv4.tcp_syncookies)
        if [[ "$current" == "0" ]]; then
            echo "[tcp_syncookies] Configuration removed. (compliant: false)"
        else
            echo "[tcp_syncookies] Failed to remove configuration. (compliant: true)"
        fi

    else
        echo "[tcp_syncookies] Invalid input. Usage: $0 true|false"
        exit 1
    fi
}

# Call the function with the provided argument
Configure-TCPSyncookies "$Enable"
