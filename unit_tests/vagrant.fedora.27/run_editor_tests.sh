#!/bin/bash
# Usage: no args runs all tests, otherwise for the specified DB

error() {
    echo "FATAL ERROR: $*"
    exit 1
}

usage() {
	error "usage: $0 -p platform [specific platform to test] -d DB [specific database to test]"
}

###################################

LOGFILE="/tmp/test_results.$$"

databases="mysql postgres sqlserver"
browsers="chrome firefox"
host="localhost"
platforms="NETCore Node PHP"


rm -f $LOGFILE

while getopts "b:d:p:" opt; do
    case $opt in
		b) browsers=$OPTARG ;; 
		d) databases=$OPTARG ;; 
		p) platforms=$OPTARG ;; 
		\?) usage ;; # Handle error: unknown option or missing required argument.
    esac
done

export DT_DATABASE_RESET="http://${host}/db_reset.php"

for database in $databases ; do
	echo "Testing $database"

	echo "Building for $database"
	export DT_DBTYPE=$database
	cd /home/vagrant/DataTablesSrc/extensions/Editor
	sh ./make.sh debug
	if [ $? -ne 0 ] ; then
		error "Build failed"
	fi

	sh /vagrant/setup_db_reset.sh $database

	for platform in $platforms ; do
		case $platform in
			PHP)
				export DT_EDITOR_URL="http://$host/extensions/Editor-$platform-Demo"
				;; 
			Node)
				export DT_EDITOR_URL="http://$host:8001"
				;; 
			NETCore)
				# Take a while for NETCore to get going, so have a little doze
				export DT_EDITOR_URL="http://$host:8002"
				sleep 5
				;; 
			*) usage ;; 
		esac

		for browser in $browsers ; do

			export DT_BROWSER=$browser

			echo "###############################################"
			echo "Running tests for:"
			echo "  DB:       $DT_DBTYPE"
			echo "  PLATFORM: $platform"
			echo "  URL:      $DT_EDITOR_URL"
			echo "  BROWSER:  $DT_BROWSER"
			echo "###############################################"

			cd /home/vagrant/datatables-system-tests/selenium
			npm run editor
			if [ $? -ne 0 ] ; then
				echo ""
				echo "There were test failutes"
				echo ""
				echo $(date) "$DT_DBTYPE - $platform - $DT_EDITOR_URL - $DT_BROWSER" >> $LOGFILE
			fi
		done
	done
done

if [ -f $LOGFILE ] ; then
	cat $LOGFILE
	rm -f $LOGFILE
	exit 1
fi

exit 0

