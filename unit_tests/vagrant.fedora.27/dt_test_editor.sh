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


databases="mysql postgres sqlserver"
host="localhost"
platforms="NETCore Node PHP"

while getopts "d:p:" opt; do
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

		echo "Running tests for $DT_EDITOR_URL"
		cd /home/vagrant/datatables-system-tests/selenium
		npm run editor
	done
done

