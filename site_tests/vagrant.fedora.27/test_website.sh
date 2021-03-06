#!/bin/bash

TEST_PASS="/vagrant/test_website_pass.txt"
TEST_LOG="/tmp/test.txt"
TEST_DIR="/tmp/site-test*"
PASS_THRESHOLD=10

rm -f $TEST_LOG
rm -rf $TEST_DIR
date | tee $TEST_LOG
npm run website | tee -a $TEST_LOG
if [ ${PIPESTATUS[0]} -ne 0 ] ; then
	echo "emailing test failure"
	echo -e "to: colin@datatables.net\nsubject: Test failed\n"| (cat - && uuencode $TEST_LOG test.txt) | ssmtp $EMAIL_ADDRESS $ADDITIONAL_EMAIL_ADDRESSES
	rm -f $TEST_PASS
else
	echo "Good result"
	date >> $TEST_PASS
	if [ $(wc -l $TEST_PASS | cut -d ' ' -f 1) -ge $PASS_THRESHOLD ] ; then
		echo -e "to: $EMAIL_ADDRESS\nsubject: Website tests passed $PASS_THRESHOLD times\n"| ssmtp $EMAIL_ADDRESS $ADDITIONAL_EMAIL_ADDRESSES
		rm -f $TEST_PASS
	fi
fi
