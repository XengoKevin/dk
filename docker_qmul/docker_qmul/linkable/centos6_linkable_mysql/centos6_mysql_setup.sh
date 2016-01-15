#!/bin/bash -e 

#~# QMUL CentOS 6 MySQL Set-up file
#
# 2015-11-23 K.Austin@qmul.ac.uk : v1.0 Created

#~# Run yum update and install:
#~# - epel-release mysql mysql-server
yum -y update; yum clean all
yum -y install \
  epel-release \
  mysql-server \
  mysql        \
  ; yum clean all

#~# check for standard MySQL innodb file, run mysql_install_db if it doesn't exist
#~# then run mysql_safe and add admin user to mysql
if [ ! -f /var/lib/mysql/ibdata1 ]; then
    mysql_install_db
    /usr/bin/mysqld_safe &
    sleep 10s

    echo "GRANT ALL ON *.* TO admin@'localhost' IDENTIFIED BY 'changeme' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

    killall mysqld
    sleep 10s
fi
