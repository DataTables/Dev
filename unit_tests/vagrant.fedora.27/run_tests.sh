#!/bin/bash
# Usage: no args runs VM once, or the arg is the sleep interval between continuous iterations

SLEEP=0
if [ $# -eq 1 ] ; then
	SLEEP=$1
fi

while : ; do
	cd ~/DataTablesSrc
	git pull 
	cd build
	./make.sh all debug

	sh /vagrant/test_unittests.sh

	[[ $SLEEP -ne 0 ]] || break;
	echo Sleeping for $SLEEP seconds before next iteration
	sleep $SLEEP
done

