#!/bin/bash -e

#~# QMUL CentOS 6 Drupal Application container image
#
# 2015-11-20 kevina: v1.0 Created
# 2015-11-25 kevina: v1.1 Updated: Changed Drush install to v6.x as 7.x is not compatible with PHP 5.3x
# 2015-12-03 I.Price@qmul.ca.uk : Added standard function calls

CNAME="chk_c6_app_drupal"
INAME="qmul/centos6_app_drupal"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
chk_get_ver


#~# Check the VER is unique
unique_ver ${INAME} ${VER}


#~# Include centos6_app_drupal_setup.sh
# Copy files from the Docker includes directory required for the build
cp -f ${INC}/centos6_app_drupal_setup.sh ./


#~# Building with image name qmul/centos6_app_Drual:v1.0
echo -e "\n\n*** Building ${INAME} container image - version ${VER} ***\n\n"

#~# Tag image name qmul/centos6_app_wordpress:latest
#~# TODO Modify code to ensure that this really is the latest
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} . \
  && docker tag -f ${INAME}:${VER} ${INAME}:latest


#~# Publish container build instructions
con_build_ins ${INAME} ${VER} ${CNAME}


#~# Publish additonal usage instructions
con_use_ins

#~# Tidy up
rm -f centos6_app_drupal_setup.sh
