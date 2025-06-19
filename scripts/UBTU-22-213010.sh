#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Restricts access to the kernel message buffer to prevent unauthorized reads.

.DESCRIPTION
    This script ensures 'kernel.dmesg_restrict = 1' is set in /etc/sysctl.conf
    and removes any conflicting definitions from other sysctl.d directories.
    It then reloads all sysctl settings to enforce the configuration immediately.

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
    STIG-ID         : UBTU-22-213010

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-213010/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to restrict dmesg access (compliant).
    Use $false to allow unrestricted dmesg access (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-213010.sh true
------------------------------------------------------------------------------
STIG_HEADER

Enable="$1"  # Store the argument (true/false)

# =========================
# Function to configure kernel.dmesg_restrict
# =========================
function Configure-KernelDmesgRestrict() {
    local State="$1"  # true to restrict, false to allow
    local Param="kernel.dmesg_restrict"
    local ConfFile="/etc/sysctl.conf"
    local DirsToClean=(
        /run/sysctl.d
        /etc/sysctl.d
        /usr/local/lib/sysctl.d
        /usr/lib/sysctl.d
        /lib/sysctl.d
    )

    # Validate input
    if [[ "$State" != "true" && "$State" != "false" ]]; then
        echo "[kernel.dmesg_restrict] Invalid input. Usage: $0 true|false"
        exit 1
    fi

    # Set desired value based on input
    local DesiredValue=$([[ "$State" == "true" ]] && echo "1" || echo "0")
    local ComplianceStatus=$([[ "$State" == "true" ]] && echo "true" || echo "false")

    # Update or append the setting in /etc/sysctl.conf
    echo "[kernel.dmesg_restrict] Setting value to $DesiredValue in $ConfFile"
    if grep -q "^$Param" "$ConfFile"; then
        sudo sed -i "s|^$Param.*|$Param = $DesiredValue|" "$ConfFile"
    else
        echo "$Param = $DesiredValue" | sudo tee -a "$ConfFile" >/dev/null
    fi

    # Remove conflicting definitions from other sysctl.d directories
    echo "[kernel.dmesg_restrict] Searching for and removing conflicting definitions..."
    for dir in "${DirsToClean[@]}"; do
        if [[ -d "$dir" ]]; then
            sudo grep -rl "^$Param" "$dir" 2>/dev/null | while read -r file; do
                echo "  - Removing $Param from $file"
                sudo sed -i "/^$Param/d" "$file"
            done
        fi
    done

    # Reload sysctl settings to apply changes
    echo "[kernel.dmesg_restrict] Reloading sysctl settings..."
    sudo sysctl --system &>/dev/null

    # Validate the result
    local Result
    Result=$(sysctl -n "$Param" 2>/dev/null)

    if [[ "$Result" == "$DesiredValue" ]]; then
        echo "[kernel.dmesg_restrict] Set to $Result (compliant: $ComplianceStatus)"
    else
        echo "[kernel.dmesg_restrict] Configuration failed. Current value: $Result (compliant: false)"
        exit 1
    fi
}

# Call the function with the provided argument
Configure-KernelDmesgRestrict "$Enable"
