#!/bin/bash
# Usage: no args runs all tests, otherwise for the specified DB

error() {
    echo "FATAL ERROR: $*"
    exit 1
}

usage() {
	error "usage: $0 -h IP [host on IP] -d DB [specific database to test]"
}

###################################


databases="mysql postgres"
host="localhost"
platforms="NETCore Node PHP"

while getopts "d:h:p:" opt; do
    case $opt in
    d) databases=$OPTARG ;; 
    p) platforms=$OPTARG ;; 
    \?) usage ;; # Handle error: unknown option or missing required argument.
    esac
done

export DT_DATABASE_RESET="http://${host}/db_reset.php"

for database in $databases ; do
	echo "Testing $database"

	echo "Building for $database"
	export DBTYPE=$database
	cd /home/vagrant/DataTablesSrc/extensions/Editor
	sh ./make.sh debug
	if [ $? -ne 0 ] ; then
		error "Build failed"
	fi

	sh /vagrant/setup_db_reset.sh $database

	for platform in $platforms ; do
		export DT_EDITOR_URL="http://$host/extensions/Editor-$platform-Demo"
		echo "Running tests for $DT_EDITOR_URL"
		cd /home/vagrant/datatables-site/test
		npm run editor
	done
done

