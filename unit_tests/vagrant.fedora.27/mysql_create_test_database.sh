#!/bin/sh

# Scripts to create (and recreate) MySQL test database
DBUSER=$(jq -r ".mysql.user" < /vagrant/db.json)
DBPASS=$(jq -r ".mysql.pass" < /vagrant/db.json)
DBNAME=$(jq -r ".mysql.db" < /vagrant/db.json)

mysql --user=${DBUSER} --password=${DBPASS} -e "DROP DATABASE ${DBNAME};" 2> /dev/null
mysql --user=${DBUSER} --password=${DBPASS} -e "CREATE DATABASE ${DBNAME};"

mysql --user=${DBUSER} --password=${DBPASS} ${DBNAME} < /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/mysql.sql
