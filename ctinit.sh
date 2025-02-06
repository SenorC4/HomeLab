#!/bin/bash

# Install sudo if not installed
echo "Installing sudo..."
apt update && apt upgrade -y && apt install sudo curl wget unattended-upgrades -y

#curl ssh keys into root
mkdir -m 700 ~/.ssh; curl https://github.com/SenorC4.keys >> ~/.ssh/authorized_keys

# Create a new user
read -p "Enter your new username: " username
read -p "Enter your new password: " password

echo "Creating user $username..."
useradd -m -s /bin/bash $username

# Set password for the user
echo "$username:$password" | chpasswd

# Add the user to the sudo group
echo "Adding $username to sudo group..."
usermod -aG sudo $username

# Move root's trusted SSH keys to lukel's .ssh directory
echo "Moving root's authorized keys to $username's .ssh directory..."
mkdir -p /home/$username/.ssh
cp /root/.ssh/authorized_keys /home/$username/.ssh/authorized_keys

# Set the correct permissions on .ssh directory and authorized_keys file
chown -R $username:$username /home/$username/.ssh
chmod 700 /home/$username/.ssh
chmod 600 /home/$username/.ssh/authorized_keys

echo "All done! $username is now created, added to sudo, and SSH keys moved."
