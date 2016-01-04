#!/bin/bash -e

#~# QMUL CentOS 6 Wordpress Application LAMP container image
#
# 2015-11-20 I.Price@qmul.ca.uk : Original file
# 2015-12-03 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-12-03 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-12-03 I.Price@qmul.ca.uk : Added standard function calls

CNAME="chk_c6_app_wp"
INAME="qmul/centos6_app_wordpress"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
chk_get_ver


#~# Check the VER is unique
unique_ver ${INAME} ${VER}


# Copy files from the Docker includes directory required for the build

#~# Include centos6_app_wordpress.sh
cp -f ${INC}/centos6_app_wordpress.sh .

#~# Include centos6_app_mysql_setup.sh
cp -f ${INC}/centos6_mysql_setup.sh .

#~# Include mod_extract_forwarded.conf
cp -f ${INC}/mod_extract_forwarded.conf .

#~# Include run-httpd.sh
cp -f ${INC}/run-httpd.sh .

#~# Include supervisord.conf
cp -f ${INC}/supervisord.conf .

#~# Include wordpress.conf
cp -f ${INC}/wordpress.conf .


#~# Building with image name qmul/centos6_app_wordpress:v1.0
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
