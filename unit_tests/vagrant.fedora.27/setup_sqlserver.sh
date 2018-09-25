#!/bin/sh

DBUSER=$(jq -r ".sqlserver.user" < /vagrant/db.json)
DBPASS=$(jq -r ".sqlserver.pass" < /vagrant/db.json)
DBNAME=$(jq -r ".sqlserver.db" < /vagrant/db.json)
MSSQL_PID='developer'


echo "Adding Microsoft repositories..."
sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-preview.repo
sudo curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo
sudo rm /etc/yum.repos.d/microsoft-prod.repo

echo "Installing SQL Server..."
sudo yum install -y mssql-server

echo "Running mssql-conf setup..."
sudo MSSQL_SA_PASSWORD=$DBPASS \
     MSSQL_PID=$MSSQL_PID \
     /opt/mssql/bin/mssql-conf -n setup accept-eula

echo "Installing mssql-tools and unixODBC developer..."
sudo ACCEPT_EULA=Y yum install -y mssql-tools unixODBC-devel

# Add SQL Server tools to the path by default:
echo "Adding SQL Server tools to your path..."
echo PATH="$PATH:/opt/mssql-tools/bin" >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Restart SQL Server after making configuration changes:
echo "Restarting SQL Server..."
sudo systemctl restart mssql-server
sudo systemctl enable mssql-server

echo "Creating tables"
# mkdir and touch a very ugly way of checking to see if the editor clone worked
mkdir -p /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql
touch /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/sqlserver.sql

sh /vagrant/sqlserver_create_test_database.sh

echo "Done!"