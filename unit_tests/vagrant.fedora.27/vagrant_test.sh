#!/bin/bash

SLEEP=0
if [ $# -eq 1 ] ; then
	SLEEP=$1
fi

while : ; do
	vagrant destroy -f
	vagrant up
	[[ $SLEEP -ne 0 ]] || break;
	sleep $SLEEP
done

