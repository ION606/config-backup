#!/bin/bash

# Configuration
PACKAGE_FILE="packages.txt"
ERROR_LOG="failed_packages.log"

# Clear previous log
> "$ERROR_LOG"

# Check if package file exists
if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: $PACKAGE_FILE not found."
    exit 1
fi

echo "Starting installation process..."

# Loop through each package in the file
while IFS= read -r package || [[ -n "$package" ]]; do
    # Skip empty lines or comments
    [[ -z "$package" || "$package" =~ ^# ]] && continue

    echo "--------------------------------------"
    echo "Installing: $package"
    
    # Run yay installation
    # --noconfirm: bypasses prompts (use with caution)
    # --needed: skips packages already up to date
    if yay -S --noconfirm --needed "$package"; then
        echo "Successfully installed $package"
    else
        echo "FAILED: $package" | tee -a "$ERROR_LOG"
    fi
done < "$PACKAGE_FILE"

echo "--------------------------------------"
echo "Process complete."
if [[ -s "$ERROR_LOG" ]]; then
    echo "Some packages failed to install. Check $ERROR_LOG for details."
else
    echo "All packages installed successfully!"
fi
