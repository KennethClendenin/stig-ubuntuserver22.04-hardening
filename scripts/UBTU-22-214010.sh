#!/bin/bash

: <<'STIG_HEADER'
------------------------------------------------------------------------------
.SYNOPSIS
    Prevents the installation of unauthenticated packages via APT.

.DESCRIPTION
    This script enforces STIG UBTU-22-214010 by removing any conflicting or
    duplicate APT configuration directives related to 'AllowUnauthenticated'
    and applying a definitive policy that sets this value to "false".
    Ensures that only cryptographically signed packages from trusted sources
    are allowed to be installed via the APT system.

.NOTES
    Author          : Kenneth Clendenin
    AI Contribution : Script generated with assistance from GitHub Copilot and OpenAI ChatGPT.
    Validation      : Final version reviewed, refined, and validated as functional
                      based on Tenable scan results.
    LinkedIn        : https://www.linkedin.com/in/kenneth-clendenin/
    GitHub          : https://github.com/KennethClendenin
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.2
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-214010

.LINK
    https://stigaview.com/products/ubuntu2204/v2r4/UBTU-22-214010/

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  : 
    Shell Ver.      : 

.PARAMETER Enable
    Use $true to enforce authenticated package installs (compliant).
    Use $false to allow unauthenticated installs (non-compliant/test only).

.EXAMPLE
    $ sudo ./UBTU-22-214010.sh true
------------------------------------------------------------------------------
STIG_HEADER

Enable="$1"  # Store the argument (true/false)
APT_CONF_DIR="/etc/apt/apt.conf.d"  # Directory for APT config snippets
STIG_FILE="$APT_CONF_DIR/00-stig-unauthenticated"  # File to enforce STIG setting

# =========================
# Function to configure APT::Get::AllowUnauthenticated
# =========================
function Configure-APTAuth() {
    local State="$1"  # true to enforce, false to allow unauthenticated

    # Validate input
    if [[ "$State" != "true" && "$State" != "false" ]]; then
        echo "[APT::Get::AllowUnauthenticated] Invalid input. Usage: $0 true|false"
        exit 1
    fi

    # Step 1: Remove all existing AllowUnauthenticated entries from all config files
    sudo grep -Rl "AllowUnauthenticated" "$APT_CONF_DIR/" | while read -r file; do
        sudo sed -i '/AllowUnauthenticated/d' "$file"
    done

    # Step 2: Create/update STIG-specific file with correct setting
    local value=$([[ "$State" == "true" ]] && echo '"false"' || echo '"true"')
    echo "APT::Get::AllowUnauthenticated $value;" | sudo tee "$STIG_FILE" > /dev/null

    # Step 3: Validate result
    if grep -q "APT::Get::AllowUnauthenticated $value;" "$STIG_FILE"; then
        echo "[APT::Get::AllowUnauthenticated] Set to $value (compliant: $([[ $State == true ]] && echo true || echo false))"
    else
        echo "[APT::Get::AllowUnauthenticated] Failed to apply setting (compliant: false)"
        exit 1
    fi
}

# Call the function with the provided argument
Configure-APTAuth "$Enable"
