#~# Dockerfile to create a BusyBox data volume 

# 2015-11-18 Ian T Price <I.Price@qmul.ac.uk>

#~# Based on busybox:latest offical repo as it's tiny - 1.1Mb
FROM busybox:latest
MAINTAINER  Ian T Price <I.Price@qmul.ac.uk>

#~# Run yum update & install all base packages:
# No yum in busybox
#RUN yum -y update; yum clean all

#~# Add a data volume for MySQL - /var/www/mysql
VOLUME /var/lib/mysql

#~# Add a data volume for html - /var/www/html
VOLUME /var/www/html

# No CMD or ENTRYPOINT required for data containers - they don't need to be running

