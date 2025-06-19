#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Enforces a 60-day maximum password lifetime for new users by setting
    PASS_MAX_DAYS to 60 in /etc/login.defs.

.DESCRIPTION
    This script configures Ubuntu 22.04 LTS to limit the maximum password
    lifetime to 60 days for newly created user accounts, aligning with
    DISA STIG compliance. It modifies the PASS_MAX_DAYS parameter in the
    /etc/login.defs file. The setting helps ensure passwords are rotated
    regularly to mitigate the risk of credential compromise.

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
    STIG-ID         : UBTU-22-411030

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-411030/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to enforce PASS_MAX_DAYS=60 (compliant).
    Use $false to remove or comment the setting (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-411030.sh true
------------------------------------------------------------------------------
STIG_HEADER

Enable="$1"  # Store the argument (true/false)
LoginDefs="/etc/login.defs"  # Path to login.defs file
Setting="PASS_MAX_DAYS"      # Setting to modify
CompliantValue="60"          # Compliant value for PASS_MAX_DAYS

# =========================
# Function to set PASS_MAX_DAYS in login.defs
# =========================
function Set-PassMaxDays() {
    local State="$1"  # true to enforce, false to comment out

    if [[ "$State" == "true" ]]; then
        # Enforce compliant value (set to 60)
        if grep -q "^$Setting" "$LoginDefs"; then
            sudo sed -i "s/^$Setting.*/$Setting $CompliantValue/" "$LoginDefs"
        else
            echo "$Setting $CompliantValue" | sudo tee -a "$LoginDefs" > /dev/null
        fi
        echo "[$Setting] Set to $CompliantValue (compliant: true)"
    elif [[ "$State" == "false" ]]; then
        # Comment out any existing setting
        sudo sed -i "s/^$Setting/# $Setting/" "$LoginDefs"
        echo "[$Setting] Commented out (compliant: false)"
    else
        echo "[$Setting] Invalid input. Usage: $0 true|false"
        exit 1
    fi
}

# Call the function with the provided argument
Set-PassMaxDays "$Enable"
