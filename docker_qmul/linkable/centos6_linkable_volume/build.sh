#!/bin/bash -e

#~# QMUL CentOS 6  Data Volume Linkable Container Image
#
# 2015-11-25 I.Price@qmul.ca.uk : Original file
# 2015-11-25 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-11-27 I.Price@qmul.ca.uk : Added standard function calls

bold=$(tput bold)
normal=$(tput sgr0)

CNAME="chk_lnk_vol"
INAME="qmul/centos6_linkable_volume"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
chk_get_ver

#~# Check the VER is unique
unique_ver ${INAME} ${VER}

#~# Building with image name qmul/centos6_compose_apache:${VER}
echo -e "\n\n*** Building ${INAME} container image - version ${VER} ***\n\n"

#~# Build image and tag with name qmul/centos6_compose_apache:latest
#~# TODO Modify code to ensure that this really is the latest
# $1 allows us to add --no-cache to the build if required
docker build --rm $1 -t ${INAME}:${VER} . \
  && docker tag -f ${INAME}:${VER} ${INAME}:latest

echo -e "\n\n${bold}*** Docker Data containers ***${normal}\n"
echo -e "\nDocker Data containers do not need to be run to be used"
echo -e "\nThe data container needs to be linked to the main container using the --volume parameter"
echo -e "\nSee Manage Data In Containers at:"
echo -e "\n\thttps://docs.docker.com/engine/userguide/dockervolumes\n\n"

