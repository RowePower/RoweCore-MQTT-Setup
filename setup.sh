#!/bin/bash

# Ensure the script is executable (useful when pulled from a repository)
chmod +x "$0"

# Function to set a new hostname
set_hostname() {
    read -p "Change Device Name y/n? " CHANGE_HOSTNAME
    if [[ "$CHANGE_HOSTNAME" =~ ^[Yy]$ ]]; then
        read -p "Enter a new device name: " NEW_HOSTNAME

        # Validate hostname (only allows letters, numbers, and hyphens, but no spaces)
        if [[ ! "$NEW_HOSTNAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
            echo "Invalid device name. Only letters, numbers, and hyphens are allowed. Try again."
            set_hostname  # Re-run the function if invalid
        else
            echo "Setting new device name: $NEW_HOSTNAME"
            sudo hostnamectl set-hostname "$NEW_HOSTNAME"
            echo "$NEW_HOSTNAME" | sudo tee /etc/hostname > /dev/null
            sudo sed -i "s/127.0.1.1.*/127.0.1.1 $NEW_HOSTNAME/g" /etc/hosts
        fi
    else
        echo "Skipping device name change."
    fi
}

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Mosquitto MQTT Broker
echo "Installing Mosquitto MQTT Broker..."
sudo apt-get install -y mosquitto mosquitto-clients
sudo systemctl enable mosquitto
sudo systemctl start mosquitto

# Install Grafana
echo "Installing Grafana..."
sudo apt-get install -y apt-transport-https software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Install Node-RED with predefined responses (bypasses interactive prompts)
echo "Installing Node-RED..."
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) <<EOF
n
n
flows.json

default
monaco
y
EOF

# Enable Node-RED to start on boot
echo "Enabling Node-RED service..."
sudo systemctl enable nodered.service

# Install required Node-RED modules
echo "Installing Node-RED modules..."
cd ~/.node-red

# Existing modules
npm install node-red-contrib-os@0.2.1
npm install node-red-dashboard@3.6.5
npm install node-red-contrib-modbus@5.43.0

# Additional modules
npm install @flowfuse/node-red-dashboard@1.22.0
npm install @flowfuse/node-red-dashboard-2-ui-iframe@1.1.0
npm install @flowfuse/node-red-dashboard-2-ui-led@1.1.0
npm install @omrid01/node-red-dashboard-2-table-tabulator@0.6.3

# Overwrite Node-RED flows.json from repository
echo "Updating Node-RED flows..."
NODE_RED_DIR="/home/$USER/.node-red"
REPO_FLOWS_FILE="/home/admin/RoweCore-MQTT-Setup/flows.json"  # Keeping your original path

if [ -f "$REPO_FLOWS_FILE" ]; then
    if [ -f "$NODE_RED_DIR/flows.json" ]; then
        echo "Backing up existing flows.json to flows_backup.json..."
        mv "$NODE_RED_DIR/flows.json" "$NODE_RED_DIR/flows_backup.json"
    fi

    echo "Copying new flows.json from repository..."
    cp "$REPO_FLOWS_FILE" "$NODE_RED_DIR/flows.json"
else
    echo "Error: flows.json not found at /home/admin/RoweCore-MQTT-Setup/"
fi

# Restart Node-RED to apply changes
echo "Restarting Node-RED..."
sudo systemctl restart nodered.service

# Prompt for a new hostname
set_hostname

# Display message and delay before reboot
echo -e "\nInstallation complete! The device will reboot in 10 seconds..."
for i in {10..1}; do
    echo -ne "Rebooting in $i seconds...\r"
    sleep 1
done
echo -e "\nRebooting now..."

# Reboot the system
sudo reboot
