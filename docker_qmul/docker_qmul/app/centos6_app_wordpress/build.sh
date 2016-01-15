#!/bin/bash -e

#~# QMUL CentOS 6 Wordpress Application LAMP container image
#
# 2015-11-20 I.Price@qmul.ca.uk : Original file
# 2015-12-03 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-12-03 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-12-03 I.Price@qmul.ca.uk : Added standard function calls
# 2016-01-08 I.Price@qmul.ca.uk : Added function call - read_img_name

CNAME="chk_c6_app_wp"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
INC_LOCAL="./includes"
source ${INC}/dock_func.fcn

#~# Read in the image name from IMAGENAME file and set INAME
read_img_name

#~# Check we have a VER from a version file
chk_get_ver

#~# Check the VER is unique
unique_ver ${INAME} ${VER}

# Copy files from the Docker includes directory required for the build
#~# Include centos6_app_mysql_setup.sh
cp -f ${INC}/centos6/centos6_mysql_setup.sh ${INC_LOCAL}
#~# Include mod_extract_forwarded.conf
cp -f ${INC}/mod_extract_forwarded.conf ${INC_LOCAL}
#~# Include run-httpd.sh
cp -f ${INC}/run-httpd.sh ${INC_LOCAL}
#~# Include supervisord.conf
cp -f ${INC}/supervisord/supervisord.conf ${INC_LOCAL}
#~# Include wordpress.conf
cp -f ${INC}/wordpress.conf ${INC_LOCAL}

#~# Building with image name qmul/centos6_app_wordpress:v1.0
echo -e "\n\n*** Building ${INAME} container image - version ${VER} ***\n\n"

#~# Build image and tag with ${VER}
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} .

#~# Tag with :latest
docker tag -f ${INAME}:${VER} ${INAME}:latest

#~# Publish container build instructions
con_build_ins ${INAME} ${VER} ${CNAME}

#~# Publish additonal usage instructions
con_use_ins

#~# Tidy up
rm -f ${INC_LOCAL}/wordpress.conf
rm -f ${INC_LOCAL}/supervisord.conf
rm -f ${INC_LOCAL}/run-httpd.sh
rm -f ${INC_LOCAL}/mod_extract_forwarded.conf
rm -f ${INC_LOCAL}/centos6_mysql_setup.sh
