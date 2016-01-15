#!/bin/bash -e 

#~# QMUL CentOS 6 Apache Set-up file
#
# 2015-11-20 martin: v1.0 Created

#~# Run yum update and install:
#~# - httpd php php-cli php-common php-mysql php-pea
yum -y update; yum clean all
yum -y install httpd php php-cli php-common php-mysql php-pear

#~# Create phpinfo.php in default web directory
echo -e "<?php\nphpinfo();\n?>" > /var/www/html/phpinfo.php
