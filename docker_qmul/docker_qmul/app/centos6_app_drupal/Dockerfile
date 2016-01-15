#~# Dockerfile to create a CentOS 6 Drupal application container image.
#
# Log 20151120: kevina: Created v1.0
#

#~# Based on Centos 6 base image
FROM qmul/centos6_lamp:latest
MAINTAINER Kevin Austin <k.austin@qmul.ac.uk>
LABEL description="This is an empty Drupal application (LAMP) image."

#~# Run centos6_app_drupal_setup.sh file from includes
ADD /etc/docker_qmul/includes/centos6_app_drupal_setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh && /root/setup.sh && rm -f /root/setup.sh

#~# Use Supervisor to manage services
RUN yum install -y python-setuptools
RUN easy_install supervisor
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]
