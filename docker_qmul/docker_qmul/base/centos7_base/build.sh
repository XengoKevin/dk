#!/bin/bash -e

#~# QMUL Centos 7 Base image
#~# Script to build a base systemd image from offical latest images
#~# Based on dockerhub.io scripts
#
# 2015-11-17 I.Price@qmul.ca.uk : Original file
# 2015-12-07 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-12-07 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-12-07 I.Price@qmul.ca.uk : Added standard function calls


CNAME="chk_c7_base"
INAME="qmul/centos7_base"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn


#~# Check we have a VER from a VERSION file
chk_get_ver


#~# Check the VER is unique
unique_ver ${INAME} ${VER}


#~# Building with image name qmul/centos6_base:${VER}
echo -e "\n\n*** Building ${INAME} container image - version ${VER} ***\n\n"

#~# Build image and tag with name qmul/centos6_base:latest
#~# TODO Modify code to ensure that this really is the latest
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} . \
  && docker tag -f ${INAME}:${VER} ${INAME}:latest


#~# Publish container build instructions
con_build_ins ${INAME} ${VER}


#~# Publish additonal usage instructions
con_use_ins
