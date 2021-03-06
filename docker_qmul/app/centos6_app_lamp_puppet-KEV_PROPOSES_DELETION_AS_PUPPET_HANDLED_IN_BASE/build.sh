#~# QMUL CentOS 6 Custom Application LAMP container image
#
# 2015-11-20 martin: v1.0 Created
# 2015-12-03 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-12-03 I.Price@qmul.ca.uk : Added update mechanism for :latest tag
# 2015-12-03 I.Price@qmul.ca.uk : Added standard function calls

CNAME="chk_c6_app_lamp_puppet"
INAME="qmul/centos6_app_lamp_puppet"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
chk_get_ver


#~# Check the VER is unique
unique_ver ${INAME} ${VER}

#~# Building with image name qmul/centos6_app_lamp_puppet:${VER}
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
