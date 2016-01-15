#~# Dockerfile to create a Custom Application LAMP image
#
# 2015-11-20: martin: Created v1.0
# 2016-01:08: kevina: Tidied up Dockerfile ready for production.
#

#~# Based on Centos 6 lamp image qmul/centos6_lamp:latest
FROM qmul/centos6_lamp:latest
MAINTAINER MDT Evans <m.d.t.evans@qmul.ac.uk>
MAINTAINER Kevin Austin <k.austin@qmul.ac.uk>
LABEL description="This is an empty LAMP application monolithic container."

#~# Install & Use the supervisord to manage services
RUN yum install -y python-setuptools
RUN easy_install supervisor
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]
