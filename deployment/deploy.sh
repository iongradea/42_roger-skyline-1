#!/bin/bash

## Import lib
#

. ./lib.sh

## Error check 
#

if [ $# != 1 ]; then
	echo -e "$RED[ERROR]$END$CYA provide <USERNAME> as first arg$END" && exit
fi

## Variables definition
#

USER=$1

# Cron variables
CRONTAB=/etc/crontab
CRON_PATH=/etc/cron.d
CRON_UPDA=update_pckg
CRON_CH=ch_crontab
CRON_FOLDER=./cron
CRON_D=cron.d

# Web server variables
CONF_APACHE=/etc/apache2
CONF_AVAI=sites-available
CONF_FILE=000-default.conf
CONF_SSL=default-ssl.conf
SITE_DIR=/var/www
SITE_RS1=rs1
SITE_SRC=./site

main() {

ok_msg "LAUNCHING MAIN DEPLOY.SH ...\n"

## Step1 : Install, initialization / logged as root
#

ok_msg "\nINSTALLING PACKAGES ...\n"

#apt install -y sudo apache2 portsentry mailutils vim iptables-persistent php-dev php libapache2-mod-php 
apt install -y sudo vim mailutils apache2 php-dev php libapache2-mod-php
ch_err
ok_msg "sudo, apache2, portsentry, mailutils, vim, iptables-persistent packages installed"

# Configure smtp mail to work with external emails
dpkg-reconfigure exim4-config
ch_err
ok_msg "exim4-config configured"


## Step2 : add user to sudo group
#

ok_msg "\nUSER INITIALIZATION ...\n"

adduser $USER sudo
ch_err
adduser $USER root
ch_err
ok_msg "$USER added to root group and sudo"

## Step3 : configure static dhcp with /30 mask
#

ok_msg "\nCONFIGURING DHCP ...\n"

sed -i.bak 's/allow-hotplug/auto/' /etc/network/interfaces
ch_err
sed -i.bak2 's/dhcp/static\n\taddress 10.11.200.253\n\tnetmask 255.255.255.252\n\tgateway 10.11.254.254/' /etc/network/interfaces
ch_err
/etc/init.d/networking restart
ch_err
ok_msg "static dhcp configured for networking service"

## Step4 : configure ssh on port 40 and prohibit root access
#

ok_msg "\nCONFIGURING SSH SERVICE ...\n"

sed -i.bak 's/#Port 22/Port 40/' /etc/ssh/sshd_config
ch_err
sed -i.bak2 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
ch_err
/etc/init.d/ssh restart
ch_err
ok_msg "ssh service on port 40 configured"

## Step5 : configure cron
#

ok_msg "\nCONFIGURING CRON ...\n"

cp $CRON_FOLDER/$CRON_D/$CRON_CH $CRON_PATH
ch_err
cp $CRON_FOLDER/$CRON_D/$CRON_UPDA $CRON_PATH
ch_err

if grep -E "$CRON_PATH/$CRON_UPDA" $CRONTAB | grep -v "@reboot"; then
	ok_msg "cron update pckg already present"
else
	echo "* 4	* * *	root	$CRON_PATH/$CRON_UPDA" >> $CRONTAB
	ch_err
	ok_msg "cron update pckg added"
fi

if grep -E "$CRON_PATH/$CRON_CH" $CRONTAB; then
	ok_msg "cron check modifs already present in crontab file"
else
	echo "* 0	* * *	root	$CRON_PATH/$CRON_CH" >> $CRONTAB
	ch_err
	ok_msg "cron check modifs in crontab script added to crontab"
fi

if grep -E "@reboot.*$CRON_PATH/$CRON_UPDA" $CRONTAB; then
	ok_msg "cron update pckg at reboot already present in crontab" 
else
	echo "@reboot root $CRON_PATH/$CRON_UPDA" >> $CRONTAB
	ch_err
	ok_msg "cron update pckg at reboot added"
fi

## Step7 : Web Server with ssl certificate
#

ok_msg "\nCONFIGURING WEB SERVER AND LAUNCHING SITE ...\n"

# Web server variables
#CONF_APACHE=/etc/apache2
#CONF_AVAI=sites-available
#CONF_FILE=000-default.conf
#CONF_SSL=default-ssl.conf
#SITE_DIR=/var/www
#SITE_RS1=rs1
#SITE_SRC=./site
RS1_CONF=rs1.conf
RS1_CONF_SSL=rs1-ssl.conf


rm -rf $SITE_DIR/$SITE_RS1
mkdir $SITE_DIR/$SITE_RS1
cp -r $SITE_SRC/* $SITE_DIR/$SITE_RS1

# Copy config from default files
cp $CONF_APACHE/$CONF_AVAI/$CONF_FILE $CONF_APACHE/$CONF_AVAI/$RS1_CONF
cp $CONF_APACHE/$CONF_AVAI/$CONF_SSL $CONF_APACHE/$CONF_AVAI/$RS1_CONF_SSL

# Modify conf files 
sed -i 's/#ServerName www.example.com/ServerName localhost/' $CONF_APACHE/$CONF_AVAI/$RS1_CONF
sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/rs1/' $CONF_APACHE/$CONF_AVAI/$RS1_CONF

# Activate rs1 site on web server
a2dissite $CONF_FILE
ch_err
a2ensite $RS1_CONF
ch_err
/etc/init.d/apache2 restart
ch_err
ok_msg "web server configuration done"

## Step final : remove ip provided by 42 dhcp server / it breaks the connection
#

echo -e "$RED[REMOVE MANUALLY OLD IP WITH 'ip addr del <IP> dev <INTERFACE>']$END"
}

main


