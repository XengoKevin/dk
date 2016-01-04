# Dockerfile to create a linkable SSH container image.
#
# Log 20151120: kevina: v1.0 Initial version created.
#

# Start with our Centos 6 base image.
FROM qmul/centos6_base:v1.0
MAINTAINER Kevin Austin <k.austin@qmul.ac.uk>
LABEL description="Linkable docker container running ssh services."

# Expose the SSH port to the docker engine
EXPOSE 22

# Run the sshd binary
CMD ["/usr/sbin/sshd", "-D"]
