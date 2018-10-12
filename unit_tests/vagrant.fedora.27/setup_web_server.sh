#!/bin/sh

echo "Setting up web site packages and configuration"

sudo dnf install -y php php-tidy php-xml php-fpm php-common php-pdo php-pdo_mysql php-pdo_pgsql php-pdo_dblib php-mbstring
sudo dnf install -y nginx

echo "Modify Nginx conf files"

sudo sed -i 's/user nginx/user vagrant/g' /etc/nginx/nginx.conf
sudo sed -i 's/worker_processes auto/worker_processes 1/g' /etc/nginx/nginx.conf
sudo sed -i 's~user = apache~user = vagrant~g' /etc/php-fpm.d/www.conf
sudo sed -i 's~group = apache~group = vagrant~g' /etc/php-fpm.d/www.conf
sudo sed -i 's~listen.acl_users = apache,nginx~listen.acl_users = apache,nginx,vagrant~g' /etc/php-fpm.d/www.conf

sudo chmod +x /var/lib/nginx
sudo chmod +x /var/lib/nginx/tmp
sudo chmod 777 /var/lib/nginx/tmp/client_body

# Link to build area
sudo mv /usr/share/nginx/html /usr/share/nginx/html.ORIG
sudo ln -s /home/vagrant/DataTablesSrc/built/DataTables /usr/share/nginx/html

# Editor Node and .NET proxies for nginx
sudo cp /vagrant/nginx-editor-node.conf /etc/nginx/conf.d/
sudo cp /vagrant/nginx-editor-netcore.conf /etc/nginx/conf.d/

echo "Start web stuff"

sudo service nginx start
sudo systemctl enable nginx
sudo service php-fpm start
sudo systemctl enable php-fpm


exit 0

