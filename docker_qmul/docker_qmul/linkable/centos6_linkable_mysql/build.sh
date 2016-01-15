#!/bin/bash -e

#~# QMUL CentOS 6 MySQL Linkable Container Image
#
# 2015-11-20 Kevin Austin <k.austin@qmul.ac.uk> : Original file
# 2015-12-08 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-12-08 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-12-08 I.Price@qmul.ca.uk : Added standard function calls

CNAME="chk_c6_lnk_mysql"
INAME="qmul/centos6_linkable_mysql"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
chk_get_ver


#~# Check the VER is unique
unique_ver ${INAME} ${VER}


# Copy files from the Docker includes directory required for the build

#~# Include centos6_app_mysql_setup.sh
cp -f ${INC}/centos6_mysql_setup.sh .


#~# Building with image name qmul/centos6_linkable_mysql:${VER}
echo -e "\n\n*** Building ${INAME} container image - version ${VER} ***\n\n"

#~# Tag image name qmul/centos6_linkable_mysql:latest
#~# TODO Modify code to ensure that this really is the latest
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} . \
  && docker tag -f ${INAME}:${VER} ${INAME}:latest


#~# Publish container build instructions
con_build_ins ${INAME} ${VER} ${CNAME}


#~# Publish additonal usage instructions
con_use_ins

