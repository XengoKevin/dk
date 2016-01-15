#~# Dockerfile to create a linkable Apache + PHP container image.
#
# 2015-11-20: kevina: v1.0 Initial version created.

#~# Based on Centos 6 qmul/base:v1.0
FROM qmul/centos6_base:v1.0
MAINTAINER Kevin Austin <k.austin@qmul.ac.uk>
LABEL description="Linkable container image running apache."

#~# Run yum update & install all base packages:
RUN yum -y update; yum clean all

#~# Setup the Apache httpd

# Add check files
ADD phpinfo.php /var/www/html/phpinfo.php
RUN echo "Apache HTTPD by Docker" >> /var/www/html/index.html

#~# Add centos6_apache_setup.sh to /etc/httpd/conf.d/
# Copy and run the Apache setup script
ADD centos6_apache_setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh && /root/setup.sh && rm -f /root/setup.sh


#~# Detail what the container should include to motd
RUN echo -e "\n[ Includes CentOS-6.7 / Apache V2.2.x / PHP V5.3.x (Standard) ]\n" >> /etc/motd

#~# Add run-httpd.sh to /
# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

#~# Run Apache service in the foreground
CMD ["/run-httpd.sh"]
