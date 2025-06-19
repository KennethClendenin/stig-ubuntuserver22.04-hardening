#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Enforces or removes the 1-day minimum password lifetime policy in /etc/login.defs.

.DESCRIPTION
    This script sets the PASS_MIN_DAYS value in /etc/login.defs to "1" (compliant) or "0" (non-compliant).
    Enforcing a minimum password lifetime prevents rapid password changes that bypass reuse policies.

.NOTES
    Author          : Kenneth Clendenin
    AI Contribution : Script generated with assistance from GitHub Copilot and OpenAI ChatGPT.
    Validation      : Final version reviewed, refined, and validated as functional 
                      based on Tenable scan results.
    LinkedIn        : https://www.linkedin.com/in/kenneth-clendenin/
    GitHub          : https://github.com/KennethClendenin
    Date Created    : 2025-06-18
    Last Modified   : 2025-06-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-411025

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-411025/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to enforce PASS_MIN_DAYS=1 (compliant).
    Use $false to set PASS_MIN_DAYS=0 (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-411025.sh true
------------------------------------------------------------------------------
STIG_HEADER

# Accepts a boolean-style parameter
Enable="$1"  # Store the argument (true/false)
LoginDefs="/etc/login.defs"  # Path to login.defs file
Setting="PASS_MIN_DAYS"      # Setting to modify

# =========================
# Function to set PASS_MIN_DAYS in login.defs
# =========================
function Set-PassMinDays() {
    local State="$1"  # true for 1, false for 0
    local Value

    if [[ "$State" == "true" ]]; then
        Value=1
    elif [[ "$State" == "false" ]]; then
        Value=0
    else
        echo "[$Setting] Invalid input. Usage: $0 true|false"
        exit 1
    fi

    # If the setting exists, update it; otherwise, append it
    if grep -qE "^\s*${Setting}\b" "$LoginDefs"; then
        sudo sed -i "s|^\s*${Setting}.*|${Setting} ${Value}|" "$LoginDefs"
    else
        echo "${Setting} ${Value}" | sudo tee -a "$LoginDefs" > /dev/null
    fi

    echo "[$Setting] Set to ${Value}. (compliant: ${State})"
}

# Call the function with the provided argument
Set-PassMinDays "$Enable"
