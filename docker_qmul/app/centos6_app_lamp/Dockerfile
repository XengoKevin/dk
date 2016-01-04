#~# Dockerfile to create a Custom Application LAMP image
#
# 2015-11-20: martin: Created v1.0
#

#~# Based on Centos 6 lamp image qmul/centos6_lamp:v1.0
FROM qmul/centos6_lamp:v1.2
MAINTAINER MDT Evans <m.d.t.evans@qmul.ac.uk>
LABEL description="This is an empty LAMP application monolithic container."

#~# Expose ports 22 80 3306 to the docker engine
EXPOSE 22 80 3306

#~# Detail what the container should include to motd
RUN echo -e "\n[ Includes CentOS-6.7 / Apache V2.2.x / PHP V5.3.x (Standard) ]" >> /etc/motd

#~# Install & Use the supervisord to manage services
RUN yum install -y python-setuptools
RUN easy_install supervisor
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]

