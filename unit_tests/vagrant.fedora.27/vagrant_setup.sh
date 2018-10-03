#!/bin/bash

echo "Check to see if this VM is running"
vagrantStatus=$(vagrant status | grep "^default" | grep "running")
if [ "$vagrantStatus" != "" ] ; then
	echo "Check to see if any mounted file systems from this VM"
	network=$(vagrant ssh -c "/sbin/ifconfig enp0s8 | grep netmask")
	vagrantIP=$(echo $network | cut -d' ' -f2)
	mounts=$(mount | grep $vagrantIP | wc -l)

	if [ $mounts -ne 0 ] ; then
		echo "Exiting: there are mounted file systems from $vagrantIP. Unmunt and try again"
		exit 1
	fi
fi

pkill -U $(id -u) ssh-agent
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

vagrant destroy -f
vagrant up
