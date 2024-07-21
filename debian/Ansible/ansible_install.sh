#!/bin/sh
set -eux

# Check if the system is Ubuntu or Debian
if [ ! -f /etc/os-release ]; then
    echo "Error: Unable to determine the distribution. This script requires Ubuntu or Debian."
    exit 1
fi

. /etc/os-release
if [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]; then
	echo "Error: This script is only compatible with Ubuntu or Debian."
	exit 1
fi
if [ -z "${VERSION_CODENAME+x}" ]; then
	echo "Error: The version codename for $ID could not be found."
	exit 1
fi

sudo apt update
sudo apt upgrade -y
sudo apt install -y \
	sshpass \
	htop net-tools iputils-ping netcat-openbsd dnsutils \
	curl nano \
	make

DEBIAN_VERSION=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)
case $DEBIAN_VERSION in
	bookworm) UBUNTU_CODENAME_EQUIVALENT=jammy ;;
	bullseye) UBUNTU_CODENAME_EQUIVALENT=focal ;;
	buster) UBUNTU_CODENAME_EQUIVALENT=bionic ;;
	*) echo "Unknown Debian version: $DEBIAN_VERSION" && exit 1 ;;
esac

KEY_PATH=/etc/apt/keyrings/ansible.asc
sudo curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" -o "$KEY_PATH"
sudo chmod a+r "$KEY_PATH"
echo "deb [signed-by=$KEY_PATH] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME_EQUIVALENT main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt update
sudo apt install -y ansible
