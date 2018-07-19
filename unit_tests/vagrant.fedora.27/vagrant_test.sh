#!/bin/bash
# Usage: no args runs VM once, or the arg is the sleep interval between continuous iterations

SLEEP=0
if [ $# -eq 1 ] ; then
	SLEEP=$1
fi

# Work out which interface to use (needed on Gemini as it has two)
export NETWORK_INTERFACE=$(route | grep '^default' | grep -o '[^ ]*$')
echo "Bridging on network interface $NETWORK_INTERFACE"

while : ; do
	vagrant destroy -f
	vagrant up
	[[ $SLEEP -ne 0 ]] || break;
	sleep $SLEEP
done

