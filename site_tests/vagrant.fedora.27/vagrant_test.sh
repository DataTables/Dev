#!/bin/bash

SLEEP=0
if [ $# -eq 1 ] ; then
	SLEEP=$1
fi

while : ; do
	vagrant up
	vagrant destroy -f
	[[ $SLEEP -ne 0 ]] || break;
	sleep $SLEEP
done

