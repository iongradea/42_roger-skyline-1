ISO SOURCE :

https://www.debian.org/CD/netinst/

https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.6.0-amd64-netinst.iso

see subject in subject_ressources !

TIPS FOR QUESTIONS : <br />

=> DHCP<br />
network configuration file :<br />
/etc/network/interfaces<br />

=> SSH<br />
ssh configuration file :<br />
/etc/ssh/sshd_config<br />

=> SERVICES<br />
script for restarting networking services :<br />
/etc/init.d/networking restart <br />
all services are located in /etc/init.d<br />

=> BOOT SERVICES<br />
script for starting services or killing them depending on runlevls :<br />
/etc/rc*/*<br />
K = for killing service<br />
S = for starting service<br />
number = sequence order for start or kill<br />
symbolic link to the service in /etc/init.d<br />
