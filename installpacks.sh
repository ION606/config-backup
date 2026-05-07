#!/bin/bash

# Configuration
PACKAGE_FILE="packages.txt"
LOG_FILE="broken_packages.log"

# Check if packages.txt exists
if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: $PACKAGE_FILE not found."
    exit 1
fi

# Clear or create the log file
echo "--- Installation Failures ($(date)) ---" > "$LOG_FILE"

echo "Starting installation process..."

# Loop through each line in the file
while IFS= read -r package || [[ -n "$package" ]]; do
    # Skip empty lines or lines starting with #
    [[ -z "$package" || "$package" =~ ^# ]] && continue

    echo "Installing: $package..."

    # Attempt installation
    if ! yay -Sy --noconfirm "$package"; then
        echo "[FAILED] $package" | tee -a "$LOG_FILE"
    else
        echo "[SUCCESS] $package"
    fi

done < "$PACKAGE_FILE"

echo "--------------------------------------"
echo "Process complete. Broken packages logged in $LOG_FILE"
