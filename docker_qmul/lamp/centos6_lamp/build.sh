#!/bin/bash -e

#~# QMUL CentOS 6 LAMP image
#
# 2015-11-20 I.Price@qmul.ca.uk : Original file
# 2015-12-03 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-12-07 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-12-07 I.Price@qmul.ca.uk : Added standard function calls

# Highlighting
bold=$(tput bold)
normal=$(tput sgr0)

CNAME="chk_c6_lamp"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
INC_LOCAL="./includes"
source ${INC}/dock_func.fcn

#~# Read in the image name from IMAGENAME file and set INAME
read_img_name

#~# Check we have a VER from a VERSION file
chk_get_ver

#~# Check the VER is unique
unique_ver ${INAME} ${VER}

# Copy files from the Docker includes directory required for the build
#~# Include centos6_app_apache_setup.sh
#~# Include mod_extract_forwarded.conf
cp -f ${INC}/mod_extract_forwarded.conf ${INC_LOCAL}
#~# Include run-httpd.sh
cp -f ${INC}/run-httpd.sh ${INC_LOCAL}
cp -f ${INC}/centos6/centos6_apache_setup.sh ${INC_LOCAL}
#~# Include centos6_app_mysql_setup.sh
cp -f ${INC}/centos6/centos6_mysql_setup.sh ${INC_LOCAL}
#~# Include centos6_idcheck_setup.sh
cp -f ${INC}/centos6/centos6_idcheck_setup.sh ${INC_LOCAL}
#~# Include centos6 idcheck RPMs
cp -f ${INC}/idcheck/idcheck*el6.x86_64.rpm ${INC_LOCAL}

#~# Building with image name qmul/centos6_lamp:${VER}
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
rm -f ${INC_LOCAL}/centos6_apache_setup.sh
rm -f ${INC_LOCAL}/centos6_mysql_setup.sh
rm -f ${INC_LOCAL}/mod_extract_forwarded.conf
rm -f ${INC_LOCAL}/run-httpd.sh
rm -f ${INC_LOCAL}/centos6_idcheck_setup.sh
rm -f ${INC_LOCAL}/idcheck*el6.x86_64.rpm
