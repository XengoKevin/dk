#~# QMUL CentOS 6 Apache Compose image
#
# 2015-11-25 I.Price@qmul.ac.uk : v1.0 Created
# 2015-11-30 I.Price@qmul.ac.uk : Added standard functions


CNAME="chk_cmp_apache"
INAME="qmul/centos6_compose_apache"
# VER=":v1.0"
# This assumes 'latest' image exists until we have a VCS
VER=""

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# TODO Hardcoded ports to 3307 2200 8000
R_PORT__MYSQL=3307
R_PORT_SSH=2200
R_PORT_HTTP=8000

#~# Stop old container function
stop_container ${CNAME}

#~# Remove old container function
rm_container ${CNAME}

#~# Create container from qmul/centos6_base:v1.0 image with name chk_base
#~# Restart always - upgrade to Docker 1.9.0 required for unless-stopped

# Alternative run commands
#docker run -d -p $R_PORT_HTTP:80 -p $R_PORT_SSH:22 -p $R_PORT_MYSQL:3306 --name=${CNAME} --restart always ${INAME}:${VER}
#docker run -d -p 80 -p 22 -p 3306 --name=${CNAME} --hostname=${CNAME}  qmul/${INAME}${VER}

#~# Run with -P auto-allocate ports due to clashes
docker run -d -P --name=${CNAME} --restart always ${INAME}${VER}


