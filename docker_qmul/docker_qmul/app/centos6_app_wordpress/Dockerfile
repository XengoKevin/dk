#~# Dockerfile to create a WordPress container image with http & MySQL
#
# 2015-11-20: I.Price@qmul.ac.uk : Created v1.0
# 2016-01-11: I.Price@qmul.ac.uk : Added MOTD

#~# Based on Centos 6 lamp image qmul/centos6_lamp:latest
FROM qmul/centos6_lamp:latest
#~# Labels (including Maintainer) are set in the ./includes/LABEL file

#~# Install WordPress
RUN yum install -y wordpress

#~# Setup Wordpress Application
ADD ./includes/wordpress.conf /etc/httpd/conf.d/wordpress.conf

#~# Setup MOTD
ADD ./includes/MOTD /etc/motd

#~# Setup MySQL
RUN (service mysqld start && service mysqld stop)

#~# Install & Use the supervisord to manage services
RUN yum install -y python-setuptools
RUN easy_install supervisor
ADD ./includes/supervisord.conf /etc/supervisord.conf

RUN yum clean all

CMD ["/usr/bin/supervisord"]
