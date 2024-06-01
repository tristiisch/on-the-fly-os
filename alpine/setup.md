# ANSWER FILE
# File to setup a new Alpine

KEYMAPOPTS="fr fr"

HOSTNAMEOPTS=SWA-MAN-001

# Contents of /etc/network/interfaces
INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
"

# Search domain of example.com, Google public nameserver
# DNSOPTS="-d example.com 8.8.8.8"

# Set timezone to UTC
TIMEZONEOPTS="UTC"

# set http/ftp proxy
# PROXYOPTS="http://webproxy:8080"

# -f Add fastest mirror
# -r Random Mirroir
# -c Enable community repo
APKREPOSOPTS="-f -c"

# Create an account
USEROPTS="-a -u- g audio,video,netdev tristiisch"
#USERSSHKEY="ssh-ed25519 AAA...... tristiisch@exemple.com"
#USERSSHKEY="https://exemple.com/tristiisch.key"

# Install SSH Server
# openssh, dropbear
SSHDOPTS=openssh
#ROOTSSHKEY="ssh-ed25519 AAA...... root@exemple.com"
#ROOTSSHKEY="https://exemple.com/root.key"

# Choose NTP server
# none, chrony, busybox, openntpd
NTPOPTS="chrony"

# Use /dev/sda as a data disk
DISKOPTS="-m data /dev/sda"

# Setup in /media/sdb1
LBUOPTS="/sda/sdb1"

APKCACHEOPTS="/media/sdb1/cache"