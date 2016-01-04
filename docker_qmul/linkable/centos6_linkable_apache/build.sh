#!/bin/bash -e

#~# QMUL CentOS 6 Apache + PHP Linkable Container Image
#
# 2015-11-20 Kevin Austin <k.austin@qmul.ac.uk> : 00 Original file
# 2015-11-25 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-11-27 I.Price@qmul.ca.uk : Added standard function calls


CNAME="chk_lnk_apache"
INAME="qmul/centos6_linkable_apache"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
chk_get_ver

#~# Check the VER is unique
unique_ver ${INAME} ${VER}

#~# Include centos6_app_apache_setup.sh
cp -f ${INC}/centos6_apache_setup.sh .

#~# Include phpinfo.php test file
cp -f ${INC}/run-httpd.sh .

#~# Include phpinfo.php test file
cp -f ${INC}/phpinfo.php .

#~# Building with image name qmul/centos6_compose_apache:${VER}
echo -e "\n\n*** Building ${INAME} container image - version ${VER} ***\n\n"

#~# Build image and tag with name qmul/centos6_compose_apache:latest
#~# TODO Modify code to ensure that this really is the latest
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} . \
  && docker tag -f ${INAME}:${VER} ${INAME}:latest

