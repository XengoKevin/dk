#~# Dockerfile to create a Stress image
#
# 2015-12-01: I.Price@qmul.ac.uk : Created v1.0


#~# Based on Fedora 23 latest image centos:latest
FROM fedora:latest
MAINTAINER Ian T Price <I.Price@qmul.ac.uk>
LABEL description="This is an utility container to enable stress testing"

RUN dnf -y install stress && dnf clean all
ENTRYPOINT ["stress"]
