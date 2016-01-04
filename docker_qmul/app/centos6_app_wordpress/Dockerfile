#~# Dockerfile to create a WordPress container image with http & MySQL
#
# 2015-11-20: Ian T Price <I.Price@qmul.ac.uk>: Created v1.0

#~# Based on Centos 6 lamp image qmul/centos6_lamp:v1.0
FROM qmul/centos6_lamp:v1.0
MAINTAINER Ian T Price <I.Price@qmul.ac.uk>
LABEL description="This is an LAMP + Wordpress application monolithic container."

#~# Install wordpress & ssmtp email service
#~# TODO - Review email service and registering hosts
RUN yum install -y \
  wordpress        \
  ssmtp            \
  ; yum clean all

#~# Setup ssmtp
RUN sed -i 's/^mailhub=mail$/mailhub=smtp.qmul.ac.uk/' /etc/ssmtp/ssmtp.conf
RUN sed -i 's/^#FromLineOverride=YES$/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf

#~# Setup Wordpress Application
ADD wordpress.conf /etc/httpd/conf.d/wordpress.conf
ADD centos6_app_wordpress.sh /usr/share/wordpress/centos6_app_wordpress.sh
RUN chmod +x /usr/share/wordpress/centos6_app_wordpress.sh
RUN sed -i 's/database_name_here/wordpress/' /usr/share/wordpress/wp-config.php
RUN sed -i 's/username_here/wordpress/' /usr/share/wordpress/wp-config.php
RUN sed -i 's/password_here/wordpress/' /usr/share/wordpress/wp-config.php

#~# Setup MySQL
RUN (service mysqld start && /usr/share/wordpress/centos6_app_wordpress.sh && rm -f /usr/share/wordpress/centos6_app_wordpress.sh && service mysqld stop)

#~# Expose ports 22 80 3306 to the docker engine
EXPOSE 22 80 3306

#~# Detail what the container should include to motd
RUN echo -e "\n[ Includes CentOS-6.7 / Apache V2.2.x / PHP V5.3.x (Standard) / Crond ]\n" >> /etc/motd

#~# Install & Use the supervisord to manage services
RUN yum install -y python-setuptools
RUN easy_install supervisor
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]

