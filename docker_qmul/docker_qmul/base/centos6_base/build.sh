#!/bin/bash -e

#~# QMUL CentOS 6 Base image
#
# 2015-11-17 I.Price@qmul.ca.uk : Original file
# 2015-11-18 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-11-20 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-11-27 I.Price@qmul.ca.uk : Added standard function calls
# 2016-01-12 I.Price@qmul.ca.uk : Added function call - read_img_name

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Read in the image name from IMAGENAME file and set INAME
read_img_name

#~# Check we have a VER from a version file
chk_get_ver

#~# Check the VER is unique
unique_ver ${INAME} ${VER}

#~# Building with image name qmul/centos6_base:${VER}
echo -e "\n*** Building ${INAME} container image - version ${VER} ***\n"

#~# Build image and tag with ${VER} & tag with :latest
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} . \
  && docker tag -f ${INAME}:${VER} ${INAME}:latest

#~# Publish container build instructions
con_build_ins ${INAME} ${VER}

#~# Publish additonal usage instructions
con_use_ins
