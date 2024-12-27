#!/bin/bash

# Script to update, upgrade, and reboot the system

# Check for root privileges
if [[ $(id -u) -ne 0 ]]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Function to ask for user confirmation
confirm_action() {
    while true; do
        read -rp "$1 (yes/no): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Update package lists
if confirm_action "Do you want to update the package lists?"; then
    sudo apt update
else
    echo "Skipping package list update."
fi

# Upgrade installed packages
if confirm_action "Do you want to upgrade installed packages?"; then
    sudo apt upgrade -y
else
    echo "Skipping package upgrade."
fi

# Upgrade specific upgradable packages
if confirm_action "Do you want to upgrade specific upgradable packages?"; then
    upgradable_packages=$(apt list --upgradable 2>/dev/null | awk -F'/' '!/^Listing/ {print $1}')
    if [[ -n "$upgradable_packages" ]]; then
        sudo apt upgrade $upgradable_packages -y
    else
        echo "No specific upgradable packages found."
    fi
else
    echo "Skipping specific package upgrade."
fi

# Update package lists again
if confirm_action "Do you want to update the package lists again?"; then
    sudo apt update
else
    echo "Skipping second package list update."
fi

# Remove unnecessary packages
if confirm_action "Do you want to remove unnecessary packages?"; then
    sudo apt autoremove -y
else
    echo "Skipping package removal."
fi

# Reboot the system
if confirm_action "Do you want to reboot the system now?"; then
    echo "Rebooting the system..."
    sudo reboot
else
    echo "Skipping reboot."
fi