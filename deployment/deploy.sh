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
sed -i.bak 's/dhcp/static\n\taddress 10.11.200.253\n\tnetmask 255.255.255.252\n\tgateway 10.11.254.254/' /etc/network/interfaces
ch_err
/etc/init.d/networking restart


## Step final : remove ip provided by 42 dhcp server
#

echo -e "$RED[REMOVE MANUALLY OLD IP WITH 'ip addr del <IP> dev <INTERFACE>']$END"
}

main


