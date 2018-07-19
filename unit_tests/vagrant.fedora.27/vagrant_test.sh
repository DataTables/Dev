#!/bin/bash
# Usage: no args runs VM once, or the arg is the sleep interval between continuous iterations

SLEEP=0
if [ $# -eq 1 ] ; then
	SLEEP=$1
fi

pkill -U $(id -u) ssh-agent
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

while : ; do
	vagrant destroy -f
	vagrant up
	[[ $SLEEP -ne 0 ]] || break;
	sleep $SLEEP
done

