#~# Dockerfile to create a linkable MySQL container image
#
# 2015-11-20: martin: Created v1.0

#~# Based on Centos 6 lamp app image qmul/centos6_app_lamp:v1.0
FROM qmul/centos6_app_lamp:v1.0
MAINTAINER MDT Evans <m.d.t.evans@qmul.ac.uk>
LABEL description="This is an empty LAMP application monolithic container with puppet (fully managed)."

#~# Detail what the container should include to motd
RUN echo -e "\n[ Includes Puppet ]" >> /etc/motd

#~# Add the puppet repo for this OS
# https://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html
RUN rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum install -y puppet
RUN groupadd -g 1000 install
