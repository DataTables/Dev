#!/bin/bash

if [ $# -eq 1 ] ; then
	DB=$1
else
	DB="mysql"
fi

echo "Creating DB PHP reset file for $DB"
DB_RESET_FILE="/home/vagrant/DataTablesSrc/built/DataTables/db_reset.php"

echo "<?php" > $DB_RESET_FILE
echo "\$output = shell_exec('sh /vagrant/${DB}_create_test_database.sh');" >> $DB_RESET_FILE
echo "echo \"<pre>\$output</pre>\";" >> $DB_RESET_FILE
echo "?>" >> $DB_RESET_FILE
