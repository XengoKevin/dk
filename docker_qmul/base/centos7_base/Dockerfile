#~# Dockerfile to create a Centos 7 image
#~# First attempt to get a Centos 7 systemd server working
#
# 2015-11-11 I.Price@qmul.ac.uk : Created v1.0

#~# Based on Centos 7 centos:latest official image
FROM centos:latest
MAINTAINER "Dan Walsh" <dwalsh@redhat.com>
MAINTAINER "Ian T Price" <I.Price@qmul.ac.uk>

ENV container docker

#~# Run yum update and install systemd; remove all the unnecessary start-up scripts
RUN yum -y update; yum clean all
RUN yum -y install systemd; yum clean all;                                  \
(cd /lib/systemd/system/sysinit.target.wants/;                              \
for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;                        \
rm -f /etc/systemd/system/*.wants/*;                                        \
rm -f /lib/systemd/system/local-fs.target.wants/*;                          \
rm -f /lib/systemd/system/sockets.target.wants/*udev*;                      \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*;                   \
rm -f /lib/systemd/system/basic.target.wants/*;                             \
rm -f /lib/systemd/system/anaconda.target.wants/*;

#~# Runs init CMD to start - not sure why
#~# TODO: Devise better startup cmd
CMD ["/usr/sbin/init"]

