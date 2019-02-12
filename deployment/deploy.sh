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
CRONTAB=/etc/crontab
CRON_PATH=/etc/cron.d
CRON_UPDA=update_pckg
CRON_CH=ch_crontab
CRON_FOLDER=./cron
CRON_D=cron.d

main() {

ok_msg "launching main deploy.sh ..."

## Step1 : Install, initialization / logged as root
#

#apt install -y sudo apache2 portsentry mailutils vim iptables-persistent 
apt install -y sudo vim
ch_err
ok_msg "sudo, apache2, portsentry, mailutils, vim, iptables-persistent packages installed"

## Step2 : add user to sudo group
#

adduser $USER sudo
ch_err
adduser $USER root
ch_err
ok_msg "$USER added to root group and sudo"

## Step3 : configure static dhcp with /30 mask
#
sed -i.bak 's/allow-hotplug/auto/' /etc/network/interfaces
ch_err
sed -i.bak2 's/dhcp/static\n\taddress 10.11.200.253\n\tnetmask 255.255.255.252\n\tgateway 10.11.254.254/' /etc/network/interfaces
ch_err
/etc/init.d/networking restart
ch_err
ok_msg "static dhcp configured for networking service"

## Step4 : configure ssh on port 40 and prohibit root access
#

sed -i.bak 's/#Port 22/Port 40/' /etc/ssh/sshd_config
ch_err
sed -i.bak2 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
ch_err
/etc/init.d/ssh restart
ch_err
ok_msg "ssh service on port 40 configured"

## Step5 : configure cron
#

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



## Step final : remove ip provided by 42 dhcp server / it breaks the connection
#

echo -e "$RED[REMOVE MANUALLY OLD IP WITH 'ip addr del <IP> dev <INTERFACE>']$END"
}

main


