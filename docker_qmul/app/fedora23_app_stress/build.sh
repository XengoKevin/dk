#!/bin/bash -e

#~# QMUL Fedora 23 Stress image
#
# 2015-12-01: I.Price@qmul.ac.uk : Created v1.0


INAME="qmul/fedora23_app_stress"

#~# Include our standard Bash functions 
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn


#~# Check we have a VER from a VERSION file
chk_get_ver


#~# Check the VER is unique
unique_ver ${INAME} ${VER}


#~# Building with image name qmul/fedora_app_stress
echo -e "\n\n*** Building ${INAME} container image - version ${VER} ***\n\n"

#~# Build image and tag with name qmul/centos6_base:latest
#~# TODO Modify code to ensure that this really is the latest
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} . \
  && docker tag -f ${INAME}:${VER} ${INAME}:latest
