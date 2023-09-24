#!/bin/bash

# Create a Linux user
echo "Creating a new user..."
read -p "Enter the username: " USERNAME
adduser $USERNAME
usermod -aG sudo $USERNAME

# Update package list
sudo apt-get update

# Install IceWM and X server
echo "Installing IceWM and X server..."
sudo apt-get install icewm xorg

# Download and install Google Chrome
echo "Downloading and installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f  # Install dependencies if needed

# Download and install Chrome Remote Desktop
echo "Downloading and installing Chrome Remote Desktop..."
sudo apt-get install python3-packaging python3-psutil python3-xdg xbase-clients
xserver-xorg-video-dummy xvfb
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg -i chrome-remote-desktop_current_amd64.deb
sudo apt-get install -f  # Install dependencies if needed

# Start Chrome Remote Desktop
echo "Starting Chrome Remote Desktop..."
DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AfJohXnkKdSIzFSK5lJZ5erma-AClrX_P8uywg9GktWfCyPRsLlF4eDS6krfJCpx_JBoFQ" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)
# Download Windows image
echo "Downloading Windows image..."
wget -O w7x64.img https://bit.ly/akuhnetw7X64

# Install QEMU
echo "Installing QEMU..."
sudo apt-get install qemu-system-x86 -y

# Start Windows in QEMU
echo "Starting Windows..."
qemu-system-x86_64 -hda w7x64.img -m 4G -smp cores=4 -net user,hostfwd=tcp::3388-:3389 -net nic -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 -vga vmware -nographic &>/dev/null &
clear

# Script will sleep for 432,000 seconds (5 days)
echo "The script will sleep for 5 days (432,000 seconds)."
sleep 432000

echo "Script completed."
