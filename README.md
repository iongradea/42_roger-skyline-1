ISO SOURCE :

https://www.debian.org/CD/netinst/

https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.6.0-amd64-netinst.iso

see subject in subject_ressources !

TIPS FOR QUESTIONS : 

=> DHCP
network configuration file :
/etc/network/interfaces

=> SSH
ssh configuration file :
/etc/ssh/sshd_config

=> SERVICES
script for restarting services :
/etc/init.d/networking restart 
all services are located in /etc/init.d

=> BOOT SERVICES
script for starting services or killing them depending on runlevls :
/etc/rc*/*
K = for killing service
S = for starting service
number = sequence order for start or kill
symbolic link to the service in /etc/init.d
