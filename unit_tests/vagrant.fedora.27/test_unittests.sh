#!/bin/bash

TEST_PASS="/vagrant/test_unittests_pass.txt"
TEST_LOG="/tmp/test.txt"
PASS_THRESHOLD=10
ERROR="NO"

rm -f $TEST_LOG
date | tee $TEST_LOG
npm run test | tee -a $TEST_LOG
if [ ${PIPESTATUS[0]} -ne 0 ] ; then
	ERROR="YES"
elif [ $(grep -q "Expected" $TEST_LOG | echo $?) -eq 0 ] ; then
	ERROR="YES"
fi

if [ "$ERROR" = "YES" ] ; then
	echo "emailing test failure"
	echo -e "to: colin@datatables.net\nsubject: Unit Test failed\n"| (cat - && uuencode $TEST_LOG test.txt) | ssmtp $EMAIL_ADDRESS $ADDITIONAL_EMAIL_ADDRESSES
	rm -f $TEST_PASS
else
	echo "Good result"
	date >> $TEST_PASS
	if [ $(wc -l $TEST_PASS | cut -d ' ' -f 1) -ge $PASS_THRESHOLD ] ; then
		echo -e "to: $EMAIL_ADDRESS\nsubject: Unit Test passed $PASS_THRESHOLD times\n"| ssmtp $EMAIL_ADDRESS $ADDITIONAL_EMAIL_ADDRESSES
		rm -f $TEST_PASS
	fi
fi
