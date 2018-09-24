#!/bin/sh

SQL=/home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/sqlite.sql
DB=/home/vagrant/editor.db

rm -f $DB
cat $SQL | sqlite3 $DB

sudo chmod 666 /home/vagrant/editor.db
