Sources iso :

https://www.debian.org/CD/netinst/

https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.6.0-amd64-netinst.iso

DHCP
network configuration file :
/etc/network/interfaces

SSH
ssh configuration file :
/etc/ssh/sshd_config

SERVICES
script for restarting services :
/etc/inti.d/networking restart 

BOOT SERVICES
script for starting services or killing them depending on runlevls :
/etc/rc*/*
K = for killing service
S = for starting service
number = sequence order for start or kill
symbolic link to the service in /etc/init.d
