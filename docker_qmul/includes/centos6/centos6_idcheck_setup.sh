#!/bin/bash -e

#~# QMUL CentOS 6 IDCheck Set-up file
#
# 2016-01-13 I.Price@qmul.ac.uk: v1.0 Created

#~# Run yum update and install:
#~# - httpd php php-cli php-common php-mysql php-pea
yum -y update
yum -y install mod_perl perl-LDAP perl-CGI perl-Net-INET6Glue

#~# Install all IDCheck RPMs
cd /usr/local/RPMS

for file in $(ls idcheck*.rpm)
    do
        rpm -Uvh $file
    done

#~# Run yum clean all
yum clean all
