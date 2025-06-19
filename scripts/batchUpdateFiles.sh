#!/bin/bash

###############################################################################
# Script Name : batch_update_files.sh
# Description : Downloads and updates specific files using curl -O
#               and makes them executable with sudo chmod +x.
# Usage       : ./batch_update_files.sh
# Notes       : Edit the URL list section to add/remove files to update.
###############################################################################

# =========================
# Define your list of URLs here
# =========================
URL_LIST=(

# Working scripts.
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/batchRunner.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-211015.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-213010.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-214010.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-253010.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-255040.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-232025.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-411025.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-611040.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-291010.sh"
  "https://raw.githubusercontent.com/KennethClendenin/stig-ubuntuserver22.04-hardening/refs/heads/main/scripts/UBTU-22-411030.sh"
)

# =========================
# Start batch download
# =========================
echo "Starting batch download of ${#URL_LIST[@]} file(s)..."

# Loop through each URL in the list
for url in "${URL_LIST[@]}"; do
    filename=$(basename "$url")  # Extract filename from URL
    echo "Downloading: $filename"

    # Download the file using curl
    if curl -fsSL -O "$url"; then
        echo "Downloaded: $filename"
        
        # Make the file executable
        if sudo chmod +x "$filename"; then
            echo "Permissions set: $filename is now executable."
        else
            echo "Failed to set executable permission on $filename"
        fi
    else
        echo "Failed to download: $url"
    fi

    echo "-----------------------------"
done

# =========================
# Batch update complete
# =========================
echo "Batch update complete."
