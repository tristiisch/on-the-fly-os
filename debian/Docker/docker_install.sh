#!/bin/sh

# Check if the system is Ubuntu or Debian
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]; then
        echo "This script is only compatible with Ubuntu or Debian."
        exit 1
    fi
else
    echo "Unable to determine the distribution. This script requires Ubuntu or Debian."
    exit 1
fi

# Add Docker's official GPG key
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
arch=$(dpkg --print-architecture)
os_version_name=$(lsb_release -cs)
echo "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.asc] \"https://download.docker.com/linux/$ID\" $os_version_name stable" \
	| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create group docker
# All users in this group can use Docker
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi

# Allow current user to use Docker
CURRENT_USER=$(whoami)
export CURRENT_USER
sudo usermod -aG docker "$CURRENT_USER"
