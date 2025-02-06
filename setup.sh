#!/bin/bash

# Function to set a new hostname
set_hostname() {
    read -p "Enter a new hostname for this Raspberry Pi: " NEW_HOSTNAME

    # Validate hostname (only allows letters, numbers, and hyphens, but no spaces)
    if [[ ! "$NEW_HOSTNAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo "Invalid hostname. Only letters, numbers, and hyphens are allowed. Try again."
        set_hostname  # Re-run the function if invalid
    else
        echo "Setting new hostname: $NEW_HOSTNAME"
        sudo hostnamectl set-hostname "$NEW_HOSTNAME"
        echo "$NEW_HOSTNAME" | sudo tee /etc/hostname > /dev/null
        sudo sed -i "s/127.0.1.1.*/127.0.1.1 $NEW_HOSTNAME/g" /etc/hosts
    fi
}

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Node-RED using the official script
echo "Installing Node-RED..."
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

# Enable Node-RED to start on boot
echo "Enabling Node-RED service..."
sudo systemctl enable nodered.service

# Install required Node-RED modules
echo "Installing Node-RED modules..."
cd ~/.node-red
npm install node-red-contrib-os@0.2.1
npm install node-red-dashboard@3.6.5
npm install node-red-contrib-modbus@5.43.0

# Prompt for a new hostname
set_hostname

# Reboot the system
echo "Installation complete! The device will reboot now..."
sudo reboot