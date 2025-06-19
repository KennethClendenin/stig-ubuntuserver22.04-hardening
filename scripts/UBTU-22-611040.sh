#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Enforces or removes the password difference requirement (difok=8) in pwquality.conf.

.DESCRIPTION
    This script sets the "difok" parameter in /etc/security/pwquality.conf to require 
    that at least 8 characters differ when a user changes their password.

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
    STIG-ID         : UBTU-22-611040

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-611040/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to enforce difok = 8 (compliant).
    Use $false to set difok = 0 (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-611040.sh true
------------------------------------------------------------------------------
STIG_HEADER

# Accepts a boolean-style parameter
Enable="$1"  # Store the argument (true/false)
ConfFile="/etc/security/pwquality.conf"  # Path to pwquality.conf
Setting="difok"  # Setting to modify

# =========================
# Function to set difok in pwquality.conf
# =========================
function Set-PasswordDifferenceRequirement() {
    local State="$1"  # true for 8, false for 0
    local Value

    if [[ "$State" == "true" ]]; then
        Value=8
    elif [[ "$State" == "false" ]]; then
        Value=0
    else
        echo "[$Setting] Invalid input. Usage: $0 true|false"
        exit 1
    fi

    # If the setting exists, update it; otherwise, append it
    if grep -qE "^\s*${Setting}\b" "$ConfFile"; then
        sudo sed -i "s|^\s*${Setting}.*|${Setting} = ${Value}|" "$ConfFile"
    else
        echo "${Setting} = ${Value}" | sudo tee -a "$ConfFile" > /dev/null
    fi

    echo "[$Setting] Set to ${Value}. (compliant: ${State})"
}

# Call the function with the provided argument
Set-PasswordDifferenceRequirement "$Enable"
