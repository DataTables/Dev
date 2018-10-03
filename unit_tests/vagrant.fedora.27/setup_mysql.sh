#!/bin/sh

echo "Setting up MySQL"

dnf install -y https://dev.mysql.com/get/mysql80-community-release-fc27-1.noarch.rpm
dnf install -y mysql-community-server

echo Starting MySQL services

sed -i 's/# default-authentication-plugin=mysql_native_password/default-authentication-plugin=mysql_native_password/g' /etc/my.cnf

systemctl start mysqld.service
systemctl enable mysqld.service

echo "Configuring MySQL"

# sometimes mysqld takes longer to start
touch /var/log/mysqld.log
count=0
while [ $count -lt 20 ] ; do
	PASSWORD=$(grep 'A temporary password is generated for root@localhost' /var/log/mysqld.log |tail -1 | awk '{print $NF}')
	if [ ! -z $PASSWORD ] ; then
		break
	fi
	
	count=$((count+1))
	sleep 1
done

cp /vagrant/mysql_my.cnf /root/.my.cnf
echo "password = $PASSWORD" >> /root/.my.cnf

DBUSER=$(jq -r ".mysql.user" < /vagrant/db.json)
DBPASS=$(jq -r ".mysql.pass" < /vagrant/db.json)
DBNAME=$(jq -r ".mysql.db" < /vagrant/db.json)

echo "Changing root password"
mysql --connect-expired-password -e "alter user root@localhost identified by '${DBPASS}';"
/bin/cp -f /vagrant/mysql_my.cnf /root/.my.cnf
echo "password = ${DBPASS}" >> /root/.my.cnf

echo "Create user"
mysql -e "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DBPASS}';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${DBUSER}'@'localhost' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"

echo "Creating tables"
# mkdir and touch a very ugly way of checking to see if the editor clone worked
mkdir -p /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql
touch /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/mysql.sql

sh /vagrant/mysql_create_test_database.sh

exit 0
