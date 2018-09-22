#!/bin/sh

DBUSER=$(jq -r ".postgres.user" < /vagrant/db.json)
DBPASS=$(jq -r ".postgres.pass" < /vagrant/db.json)
DBNAME=$(jq -r ".postgres.db" < /vagrant/db.json)

cp /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/postgres.sql /tmp/postgres.sql
chmod +r /tmp/postgres.sql
sudo -u postgres PGPASSWORD="${DBPASS}" psql -d ${DBNAME} -U ${DBUSER} -f /tmp/postgres.sql
rm /tmp/postgres.sql

echo "Completed Postgres configuration"
