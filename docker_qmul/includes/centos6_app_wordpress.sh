#!/bin/bash

#~# Script to setup WordPress MySQL Database

echo Setting up Wordpress Mysql Database
mysql -e 'CREATE DATABASE wordpress;'
mysql -e 'CREATE USER wordpress@localhost;'
mysql -e 'CREATE USER wordpress@172.17.42.1;'
mysql -e 'SET PASSWORD FOR wordpress@localhost= PASSWORD("wordpress")';
mysql -e 'SET PASSWORD FOR wordpress@172.17.42.1= PASSWORD("wordpress123")';
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@localhost IDENTIFIED BY 'wordpress';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@172.17.42.1 IDENTIFIED BY 'wordpress123';"
mysql -e 'FLUSH PRIVILEGES;'
echo Done

