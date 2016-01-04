#~# QMUL CentOS 6 data volume linkable image
#
# 2015-11-25 I.Price@qmul.ac.uk : v1.0 Created
# 2015-11-30 I.Price@qmul.ac.uk : Added standard functions


CNAME="chk_c6_lnk_vol"
INAME="qmul/centos6_linkable_volume"
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

#~# Create container from busybox:latest image with name chk_c6_lnk_vol

# Run either -P or the -p options, not both.  -P requires 'EXPOSE 22 80 3306' in Dockerfile
#  -P                       \
#  -p $R_PORT_HTTP:80       \
#  -p $R_PORT_SSH:22        \
#  -p $R_PORT_MYSQL:3306    \

docker run -d              \
  -P                       \
  -e "TERM=xterm"          \
  --memory 256M            \
  --memory-swap 384M       \
  --cpu-period=50000       \
  --cpu-quota=25000        \
  --blkio-weight=500       \
  --ulimit nproc=1024      \
  --ulimit core=0          \
  --ulimit nofile=1024     \
  --name=${CNAME}          \
  --hostname=${CNAME}      \
  ${INAME}${VERLOCAL}

# Not used here
#  --restart unless-stopped \

echo -e "\n*** The ports for the new conatiner are:\n"
docker port ${CNAME} | sort -n | column -t
echo

