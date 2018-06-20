#!/bin/sh

if [ $# -ne 1 ] ; then
	echo "No user detected, so not setting up git"
	exit 0
fi

case $1 in 
	colin) echo Setting up git for Colin
		git config --global user.email colin@datatables.net
		git config --global user.name "Colin Marks"
		;;

	allan) echo Setting up git for Allan
		git config --global user.email allan@datatables.net
		git config --global user.name "Allan Jardine"
		;;

	*) echo "Unknown user detect, so not setting up git"
		;;
esac


