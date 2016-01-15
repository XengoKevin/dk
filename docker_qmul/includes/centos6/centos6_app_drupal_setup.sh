#!/bin/bash -e

#~# QMUL CentOS 6 Drupal Set-up file
#
# 2015-11-23 K.Austin@qmul.ac.uk : v1.0 Created

#~# Run yum update and install:
#~# - php-dom php-gd tar which
#  Need tar to extract Drupal core, php-dom and php-gd are dependencies.
yum -y update; yum clean all
yum -y install \
  tar          \
  php-dom      \
  php-gd       \
  which        \
  ; yum clean all

#~# Start MySQL - needs to be running as part of the installation process
service mysqld start

#~# Download and install Composer Dependency Manager for PHP
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

#~# Download and install Drush (DRUpal SHell) using composer
composer global require drush/drush:6.*
composer global update
ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

#~# Download Drupal and create core directories required
rm -rf /var/www/html && cd /var/www && drush dl drupal && mv /var/www/drupal* /var/www/html
mkdir -p /var/www/html/sites/default/files && chmod -R a+w /var/www/html/sites/default && mkdir -p /var/www/html/sites/all/modules/contrib && mkdir /var/www/html/sites/all/modules/custom && mkdir -p /var/www/html/sites/all/themes/contrib && mkdir /var/www/html/sites/all/themes/custom
chown -R apache:apache /var/www/

#~# Install Drupal using drush
cd /var/www/html
drush si -y minimal --db-url=mysql://admin:changeme@localhost/drupal --account-pass=admin

#~# Allow Drupal access to .htaccess to generate clean URLs via httpd.conf
sed -i ':a;N;$!ba;s/AllowOverride None/AllowOverride All/2' /etc/httpd/conf/httpd.conf

#~# Close down MySQL connection
service mysqld stop
