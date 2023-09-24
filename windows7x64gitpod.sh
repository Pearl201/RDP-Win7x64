#!/bin/bash

# Create a Linux user interactively
read -p "Enter the username: " USERNAME
read -sp "Enter the password: " PASSWORD
echo  # Move to a new line after password input

# Set default values for full name, room number, keyboard layout, and locale
FULL_NAME="Your Full Name"
ROOM_NUMBER="123"
KEYBOARD_LAYOUT="us"
LOCALE="en_US.UTF-8"

# Create the user with default values
echo "Creating a new user: $USERNAME..."
useradd -m -p $(openssl passwd -1 $PASSWORD) -c "$FULL_NAME" -g users -G wheel -s /bin/bash -d /home/$USERNAME $USERNAME

# Set additional user information
chfn $USERNAME <<EOF
$FULL_NAME
$ROOM_NUMBER

EOF

# Set keyboard layout and locale
echo "Setting keyboard layout and locale..."
localectl set-keymap $KEYBOARD_LAYOUT
localectl set-locale $LOCALE

# The rest of your script...
# Update package list, install software, etc.


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

sudo apt-get install chrome-remote-desktop
# Start Chrome Remote Desktop
echo "Starting Chrome Remote Desktop..."
DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AfJohXnkKdSIzFSK5lJZ5erma-AClrX_P8uywg9GktWfCyPRsLlF4eDS6krfJCpx_JBoFQ" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)
# Download Windows image
echo "Downloading Windows image..."
#wget -O w7x64.img https://bit.ly/akuhnetw7X64

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
