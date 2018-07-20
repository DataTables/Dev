#!/bin/bash

VERSION_URL="https://datatables.net/feeds/versions"
VERSION_FILE="/tmp/versions"
TEMP_FILE="/tmp/download.url"
EXPECTED_COMPONENTS=16
STATUS=0

email_message() {
	echo -e "to: $EMAIL_ADDRESS\nsubject: URL Test failed: $*\n"| ssmtp $EMAIL_ADDRESS $ADDITIONAL_EMAIL_ADDRESSES
	return
}

error() {
	echo "FATAL ERROR: $*"
	email_message "$*"
	exit 1
}

warn() {
	echo "WARNING: $*"
	email_message "$*"
	STATUS=1
}

log() {
	# echo "LOG: $*"
	return
}

get_file() {
	OUTFILE=$1
	log "Checking $2"
	rm -f $OUTFILE
	wget -q -O $OUTFILE $2
	if [ $? -ne 0 ] ; then
		warn "Unable to download $2"
	fi
	if [ $(wc -c $OUTFILE | cut -d ' ' -f 1) -eq 0 ] ; then
		warn "$2 [$OUTFILE] is unexpectedly empty"
	fi
}

get_value() {
	value=$(jq -r $1 $VERSION_FILE)
	if [ $? -ne 0 ] ; then
		error "Unable to get value of $1"
	fi
	if [ "$value" = "null" ] ; then
		value=""
	fi

 	echo $value
}

test_file() {
	url=$(get_value $1)
	if [ "$url" = "" ] ; then
		log "$1 has an empty URL"
	else
		get_file $TEMP_FILE "$url"
	fi
}

test_files() {
	test_file ".$1.$2.files.debug.path"
	test_file ".$1.$2.files.min.path"
	test_file ".$1.$2.files.css.path"
	test_file ".$1.$2.files.cssMin.path"
}

test_component() {
	test_file ".$1.release.package"
	test_files $1 "release"
	test_files $1 "nightly"
}

#################
echo "Running website link test"

# get the version file and ensure size we expected
get_file $VERSION_FILE $VERSION_URL
if [ $(jq 'keys[]' $VERSION_FILE  | wc -l) -ne $EXPECTED_COMPONENTS ] ; then
	error "Version file didn't contain what was expected!"
fi

# Now let's do the checking, innit
for i in $(jq -r 'keys[]' $VERSION_FILE) ; do
	log "$i"
	if [ "$i" != "Plugins" ] ; then
		test_component $i
	fi
done

exit $STATUS

