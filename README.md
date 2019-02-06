ROGER-SKYLINE-1 :<br/>

Ce sujet est une initiation aux bases de l’administration système et réseau.<br />

Ce projet permettera de procéder à l’installation d’une Virtual Machine, de découvrir les bases système et réseau ainsi que les nombreux services utilisés sur une machine serveur.<br />


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
	- ssh-copy-id -i ~/.ssh/id_rsa_rs1.pub user@host <br />
5. server : iptables, see config_files/fw_dos_portscan <br />
	- sudo apt-get install iptables-persistent <br />
	- iptables-save > /etc/iptables/rules.v4 <br />
	- iptables -L -v -n (shows with verbose) <br />
6. server : stop services <br />
	- sudo /etc/init.d/SERVICE stop <br />
7. & 8. server : cron for jobs (check modifications /etc/crontab and update packages) <br />
	- modificatin at /etc/crontab <br />
9. install mail service : <br />
	- apt-get install mailutils (install mail services SMTP, POP etc.) <br />
	- dpkg-reconfigure exim4-config (this configures all mail services SMTP, POP etc. to access external mail) <br />
10. web server : <br /> 
	- apt install apache2 <br />
	- see sources docs for articles on installing php for apache on debian <br />

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

=> VIRTUALBOX network configuration : <br />
The network for the virtual machine can be either configured as NAT or Bridged <br />
- NAT : creates an internal network for the machines in virtual box, can put any IP address for the machine <br />
		It is necessary to configure a port forwarding to the IP of the machine (ip a) on a specific port <br />
		to connect it to the network (external) <br />
- Bridged : it is added to the network of the machines and can be connected with ssh to the IP of the machine <br />

=> WEB SERVER : <br />
- /etc/apache2 contains the configuration files for apache2 <br />
	sites-available : config files for sites, to be disabled or enabled with the following command <br />
	sudo a2dissite 000-default.conf, sudo a2ensite 000-default.conf <br />
	000-default.conf and default-ssl.conf are the 2 default config files for the default apache2 page <br />
- /var/www contains the different websites, the default one is in html with the server info page of apache2 <br />
- sudo apt-get install php-dev <br />
- sudo apt-get install php libapache2-mod-php <br /> 

=> annex : to configure mail server, allow access with iptables to one of the ports for SMTP, IMAP, POP etc. <br />
			configure a mail server listening on these ports <br />

=> Sources docs :<br />
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-iptables-on-ubuntu-14-04 <br />
https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands <br />
https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture <br />
https://serverfault.com/questions/410604/iptables-rules-to-counter-the-most-common-dos-attacks <br />
https://www.paloaltonetworks.com/cyberpedia/what-is-a-denial-of-service-attack-dos <br />
https://www.thegeekstuff.com/2011/06/iptables-rules-examples/?utm_source=feedburner <br />
https://linoxide.com/firewall/block-common-attacks-iptables/ <br/>
https://linuxconfig.org/how-to-make-iptables-rules-persistent-after-reboot-on-linux <br />
https://stackoverflow.com/questions/47691057/debian-9-the-php5-packages-is-not-installed <br />
https://stackoverflow.com/questions/12142172/apache-shows-php-code-instead-of-executing <br />
https://stackoverflow.com/questions/5004233/jquery-ajax-post-example-with-php <br />

to remove all ufw chains and rules : <br />
https://gist.github.com/funkjedi/88c31179d455b9c6edb2b31b9564ede1 <br />

Other interesting github : <br />
https://github.com/romontei <br />
