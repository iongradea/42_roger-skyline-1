ISO SOURCE :<br />
https://www.debian.org/CD/netinst/ <br />
https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.6.0-amd64-netinst.iso<br />

see subject in subject_ressources ! <br />

WORKFLOW (packages installed, VM config) : <br />
1. server : apt-get install sudo <br />
2. server : add igradea to sudo and root groups <br />
3. server : for static ip, modify /etc/network/interface + restart networking services
4. client : <br />
	- ssh-keygen -f ~/.ssh/id_rsa_rs1 -t rsa -b 4096 <br />
	- ssh-copy-id -i ~/.ssh/id_rsa_rs1.pub user@host
5. server : sudo apt-get update && sudo apt-get install ufw <br />
	- see firewall, ddos <br />

TIPS FOR QUESTIONS : <br />

=> DHCP<br />
network configuration file :<br />
/etc/network/interfaces<br />

=> SSH<br />
ssh configuration file :<br />
/etc/ssh/sshd_config<br />
Connection with ssh key (private) on port 40<br />
ssh igradea@10.11.200.253 -p 40 -i id_rsa_rs1<br />

=> SERVICES<br />
all services are located in /etc/init.d<br />
script for restarting networking services :<br />
/etc/init.d/networking restart <br />

=> BOOT SERVICES<br />
script for starting services or killing them depending on runlevls :<br />
/etc/rc*/*<br />
K = for killing service<br />
S = for starting service<br />
number = sequence order for start or kill<br />
symbolic link to the service in /etc/init.d<br />

=> FIREWALL, DDOS <br />
- sudo ufw enable <br />
- sudo ufw default deny incoming <br />
- sudo ufw default allow outgoing <br />
- sudo ufw allow in 40/tcp (this is because ssh is configured on port 40 and not 22) <br />
- sudo limit 40/tcp (rules changed with LIMIT IN) <br />
other useful command : <br />
- sudo ufw status verbose <br />
- sudo ufw status numberer (to remove rules) <br />
- sudo iptables -L | grep ufw-user (iptables lists all rules)

=> PORT SCANNING : <br />

Sources docs :
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-iptables-on-ubuntu-14-04
https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture

to remove all ufw chains and rules :
https://gist.github.com/funkjedi/88c31179d455b9c6edb2b31b9564ede1
