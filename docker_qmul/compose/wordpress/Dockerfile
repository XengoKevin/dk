#~# Dockerfile to create a wordpress linked containers image

# 2015-11-17: Ian T Price <I.Price@qmul.ac.uk>: Created v1.0
# 2015-11-18 ITP: Removed SSH keys
# 2015-11-18 ITP: Added default packages and directories
# 2015-11-20 ITP: Added acl
# 2015-11-20 martin: Added sudo, telnet, bind-utils and ltrace

#~# Based on wordpress offical image from dockerhub.io
FROM wordpress
MAINTAINER The CentOS Project <cloud-ops@centos.org>
MAINTAINER Ian T Price <I.Price@qmul.ac.uk>

#~# Run yum update & install all base packages:
#~# - epel-release acl bind-utils dig lsof nano openssh-server passwd
#~# - ltrace strace sudo telnet tree wget which

RUN rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum -y update; yum clean all
RUN yum -y install \
  epel-release     \
  acl              \
  bind-utils       \
  dig              \
  lsof             \
  nano             \
  openssh-server   \
  passwd           \
  ltrace           \
  strace           \
  sudo             \
  telnet           \
  tree             \
  wget             \
  which            \
  puppet           \
  ; yum clean all

#~# Set-up QMUL default directories:
#  These should all be owned by root and install group rwx
#  Left at root:root for now - puppet can sort as required

#~# For local source builds
RUN mkdir -p /usr/local/src
RUN chmod 770 /usr/local/src
RUN chown root:root /usr/local/src

#~# For 3rd party non-repoed RPMS
RUN mkdir -p /usr/local/RPMS
RUN chmod 770 /usr/local/RPMS
RUN chown root:root /usr/local/RPMS

#~# For tarballs
RUN mkdir -p /usr/local/distrib
RUN chmod 770 /usr/local/distrib
RUN chown root:root /usr/local/distrib


#~# Setup sshd

# This creates the ssh directories & set-up files
#~# TODO: Change sshd setup from service start/stop
RUN (service sshd start && service sshd stop)

# Allow root to ssh into the server
RUN sed -i 's/^#PermitRootLogin\syes$/PermitRootLogin yes/' /etc/ssh/sshd_config

#~# Prevent slow response from ssh by turning off DNS
RUN sed -i 's/^#UseDNS yes$/UseDNS no/' /etc/ssh/sshd_config


#~# Run the ssh server - currently disabled - no entry point
# ENTRYPOINT ["/usr/sbin/sshd", "-D"]
