#!/bin/sh

SQL=/home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/sqlite.sql
cat $SQL | sqlite3 /home/vagrant/editor.db
