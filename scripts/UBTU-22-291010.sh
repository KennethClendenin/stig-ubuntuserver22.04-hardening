#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Enables or disables USB mass storage kernel module to prevent auto-mounting.

.DESCRIPTION
    This script prevents loading of the usb-storage module by:
      - Blacklisting the usb-storage module
      - Setting the install command to /bin/false
    This complies with STIG requirement to prevent unauthorized USB device use.

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
    STIG-ID         : UBTU-22-291010

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-291010/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to block USB mass storage devices (compliant).
    Use $false to unblock USB mass storage devices (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-291010.sh true
------------------------------------------------------------------------------
STIG_HEADER

# Parameter: true (block USB storage), false (allow USB storage)
Enable="$1"  # Store the argument (true/false)
ConfFile="/etc/modprobe.d/stig.conf"  # Config file for module blacklisting

# =========================
# Function to configure USB mass storage kernel module
# =========================
function Configure-USBMassStorage() {
    local State="$1"  # true to block, false to unblock

    if [[ "$State" == "true" ]]; then
        # Remove any existing (commented or uncommented) lines for usb-storage
        sudo sed -i '/^\s*#\?\s*install usb-storage/d' "$ConfFile" 2>/dev/null || true
        sudo sed -i '/^\s*#\?\s*blacklist usb-storage/d' "$ConfFile" 2>/dev/null || true
        # Add lines to block the module
        echo "install usb-storage /bin/false" | sudo tee -a "$ConfFile" > /dev/null
        echo "blacklist usb-storage" | sudo tee -a "$ConfFile" > /dev/null
        echo "[usb-storage] Blocking enabled (compliant: true). Changes written to $ConfFile"
    elif [[ "$State" == "false" ]]; then
        # Remove any lines that block the module
        sudo sed -i '/^\s*install usb-storage/d' "$ConfFile" 2>/dev/null || true
        sudo sed -i '/^\s*blacklist usb-storage/d' "$ConfFile" 2>/dev/null || true
        echo "[usb-storage] Blocking removed (compliant: false). USB mass storage allowed."
    else
        echo "[usb-storage] Invalid input. Usage: $0 true|false"
        exit 1
    fi
}

# Call the function with the provided argument
Configure-USBMassStorage "$Enable"
