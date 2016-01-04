# Dockerfile to create a linkable MySQL container image.
#
# 2015-11-20: Kevin Austin: v1.0 Initial version created.
# 2015-12-08: Ian T Price <I.Price@qmul.ac.uk>: Added MOTD & tidied up
#

# Start with our Centos 6 base image.
FROM qmul/centos6_base:v1.0
MAINTAINER Kevin Austin <k.austin@qmul.ac.uk>
LABEL description="This is an MySQL application monolithic container."

# Copy and run the setup script
ADD centos6_mysql_setup.sh /root/centos6_mysql_setup.sh
RUN chmod +x /root/centos6_mysql_setup.sh && /root/centos6_mysql_setup.sh && rm -f /root/centos6_mysql_setup.sh

# Expose the MySQL port to the docker engine
EXPOSE 3306

#~# Detail what the container should include to motd
RUN echo -e "\n[ Includes CentOS-6.7 / MySQL 5.x ]\n" >> /etc/motd

# Run the mysqld_safe binary
CMD ["/usr/bin/mysqld_safe"]
