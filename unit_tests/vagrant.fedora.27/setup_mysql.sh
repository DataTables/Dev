#!/bin/sh

echo "Setting up MySQL"

dnf install -y https://dev.mysql.com/get/mysql80-community-release-fc27-1.noarch.rpm
dnf install -y mysql-community-server

echo Starting MySQL services

sed -i 's/# default-authentication-plugin=mysql_native_password/default-authentication-plugin=mysql_native_password/g' /etc/my.cnf

systemctl start mysqld.service
systemctl enable mysqld.service

echo "Configuring MySQL"

# sometimes mysqld takes longer to start, should find a tidy way of waiting for this
sleep 5
export PASSWORD=$(grep 'A temporary password is generated for root@localhost' /var/log/mysqld.log |tail -1 | awk '{print $NF}')
cp /vagrant/mysql_my.cnf /root/.my.cnf
echo "password = $PASSWORD" >> /root/.my.cnf

echo "Changing root password"
mysql --connect-expired-password -e "alter user root@localhost identified by 'Pa55word123.';"
/bin/cp -f /vagrant/mysql_my.cnf /root/.my.cnf
echo "password = Pa55word123." >> /root/.my.cnf

echo "Create sa user"
mysql < /vagrant/mysql_create_sa_user.sql

echo "Creating tables"
# mkdir and touch a very ugly way of checking to see if the editor clone worked
mkdir -p /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql
touch /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/examples/sql/mysql.sql

sh /vagrant/mysql_create_test_database.sh

exit 0
