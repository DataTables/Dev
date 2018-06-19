CREATE USER 'sa'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Pa55word123.';
GRANT ALL PRIVILEGES ON *.* TO 'sa'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
