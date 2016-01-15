#~# Dockerfile to create a Centos 6 LAMP image
#
# 2015-11-18 Ian T Price <I.Price@qmul.ac.uk> : Orignal file
# 2015-11-20 Ian T Price <I.Price@qmul.ac.uk> : Added MySQL yum and set-up & removed start-up for httpd
# 2016-01-08 Kevin Austin <k.austin@qmul.ac.uk>: Preparation for moving to production.  Removed blank index.html and MOTD.
# 2016-01-11: kevina: Added idcheck.

#~# Based on Centos 6 base image qmul/centos6_base:latest
FROM qmul/centos6_base:latest
MAINTAINER Ian T Price <I.Price@qmul.ac.uk>
MAINTAINER Kevin Austin <k.austin@qmul.ac.uk>

#~# Run yum update and install
#~# - httpd mod_extract_forwarded mysql mysql-server
#~# - php php-cli php-common php-mysql php-pear

RUN yum install -y        \
  httpd                   \
  mod_extract_forwarded   \
  mysql                   \
  mysql-server            \
  php                     \
  php-cli                 \
  php-common              \
  php-mysql               \
  php-pear

#~# Setup Apache
#~# Add mod_extract_forwarded.conf to /etc/httpd/conf.d
ADD ./includes/mod_extract_forwarded.conf /etc/httpd/conf.d/mod_extract_forwarded.conf

#~# Copy and run the Apache setup script to /root/setup.sh; rm if successful
ADD ./includes/centos6_apache_setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh && /root/setup.sh && rm -f /root/setup.sh

#~# Copy and run the MySQL setup script to /root/setup.sh; rm if successful
ADD ./includes/centos6_mysql_setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh && /root/setup.sh && rm -f /root/setup.sh

#~# Copy and run the IDCheck setup script to /root/setup.sh; rm if successful
ADD ./includes/idcheck*.el6.x86_64.rpm /usr/local/RPMS/
ADD ./includes/centos6_idcheck_setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh && /root/setup.sh && rm -f /root/setup.sh

#~# Copy simple startup script to avoid issues with old PIDs
ADD ./includes/run-httpd.sh /root/run-httpd.sh
RUN chmod -v +x /root/run-httpd.sh
# CMD ["/run-httpd.sh"]

#~# Run yum clean all
RUN yum clean all

#~# Run apache in the foreground - no daemon
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
