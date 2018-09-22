#!/bin/sh

echo "Setting up Postgres"

sudo dnf install -y postgresql-server postgresql-contrib

echo "Configuring Postgres"

sudo postgresql-setup --initdb --unit postgresql
sudo echo "
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
local   all             sa                                      md5
local   all             all                                     peer
host    all             all             0.0.0.0/0               md5
host    all             all             ::1/128                 md5
" > /var/lib/pgsql/data/pg_hba.conf

sudo echo "listen_addresses = '*'" >> /var/lib/pgsql/data/postgresql.conf

echo "Starting Postgres services"

systemctl start postgresql.service
systemctl enable postgresql.service

echo "Postgres user and test db"

DBUSER=$(jq -r ".postgres.user" < /vagrant/db.json)
DBPASS=$(jq -r ".postgres.pass" < /vagrant/db.json)
DBNAME=$(jq -r ".postgres.db" < /vagrant/db.json)

cd /tmp
sudo -u postgres psql -c "CREATE USER \"${DBUSER}\" WITH PASSWORD '${DBPASS}';"
sudo -u postgres psql -c "CREATE DATABASE \"${DBNAME}\" OWNER \"${DBUSER}\";"

echo "localhost:5432:${DBUSER}:${DBPASS}" > ~/.pgpass

echo "Populating postgres database"

sh /vagrant/postgres_create_test_database.sh

exit 0
