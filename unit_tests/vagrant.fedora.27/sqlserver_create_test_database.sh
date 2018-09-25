#!/bin/sh

# Scripts to create (and recreate) MS SQL Server test database
DBUSER=$(jq -r ".sqlserver.user" < /vagrant/db.json)
DBPASS=$(jq -r ".sqlserver.pass" < /vagrant/db.json)
DBNAME=$(jq -r ".sqlserver.db" < /vagrant/db.json)
SQLCMD="/opt/mssql-tools/bin/sqlcmd"
SQLFILE=/home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/sqlserver.sql

$SQLCMD -S localhost -U $DBUSER -P $DBPASS -Q "DROP DATABASE ${DBNAME};"
$SQLCMD -S localhost -U $DBUSER -P $DBPASS -Q "CREATE DATABASE ${DBNAME};"
$SQLCMD -S localhost -U $DBUSER -P $DBPASS -d $DBNAME -i $SQLFILE 
