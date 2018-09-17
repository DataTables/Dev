#!/bin/sh

# Scripts to create (and recreate) MySQL test database

mysql --user='sa' --password='Pa55word123.' -e "DROP DATABASE test;" 2> /dev/null
mysql --user='sa' --password='Pa55word123.' -e "CREATE DATABASE test;"

mysql --user='sa' --password='Pa55word123.' test < /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/mysql.sql
