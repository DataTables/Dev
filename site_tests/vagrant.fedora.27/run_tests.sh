#!/bin/bash
# Usage: no args runs VM once, or the arg is the sleep interval between continuous iterations

SLEEP=0
if [ $# -eq 1 ] ; then
	SLEEP=$1
fi


cd /home/vagrant/datatables-site/test

while : ; do
	git pull 
	sh /vagrant/test_website.sh
	sh /vagrant/test_links.sh
	[[ $SLEEP -ne 0 ]] || break;
	echo Sleeping for $SLEEP seconds before next iteration
	sleep $SLEEP
done

