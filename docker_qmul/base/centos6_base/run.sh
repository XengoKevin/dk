#!/bin/bash -e

#~# QMUL CentOS 6 Base image
#
# 2015-11-26 I.Price@qmul.ac.uk : v1.0 Created
# 2015-12-03 I.Price@qmul.ac.uk : Updated build tags and turned comments into Usage
# 2015-12-03 I.Price@qmul.ac.uk : Added standard function calls
# 2015-12-04 I.Price@qmul.ac.uk : Added Resource limits & ulimits
# 2015-12-23 I.Price@qmul.ac.uk : Converted to generic run script with parameter files

function usage_fcn ()
{
  echo -e "\n\tUsage:\n\t\t${0} [-h] [-i] [-c] [-s] [-r] [-v]\n"
  echo -e "\n\t\tThis script creates a container using pararmeter files\n"
  echo -e "\n\t\t[-c] Container name"
  echo -e "\n\t\t[-h] Host name"
  echo -e "\n\t\t[-i] Image name"
  echo -e "\n\t\t[-s] Stop container"
  echo -e "\n\t\t[-r] Remove container (infers -s )"
  echo -e "\n\t\t[-v] Use 'latest' Image rather than VERSION file\n"
}

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source "${INC}/dock_func.fcn"

#~# Check we have a VER from a VERSION file
## Set VERLOCAL to "" to use :latest tag
chk_get_ver
VERLOCAL=":${VER}"

echo "$@"
CNAME="chk_c6_base"


# Get commandline parameters or display usage
while getopt ":c:h:i:s:r:v" opt; do
  case $opt in
    c) #~# Get/Set Container name parameter first
       echo -e "\n -${opt} was triggered, Parameter: $OPTARG\n" >&2
       CNAME=${OPTARG}
       ;;
    h) #~# Host Name
       echo -e "\n -${opt} was triggered, Parameter: $OPTARG\n" >&2
       HNAME=${OPTARG}
       ;;
    i) #~# Image Name
       echo -e "\n -${opt} was triggered, Parameter: $OPTARG\n" >&2
       INAME=${OPTARG}
       ;;
    s) #~# Stop old container
       stop_container ${CNAME}
       ;;
    r) #~# Stop and remove old container
       #~# TODO : Need to ask user if they really mean this
       stop_container ${CNAME}
       rm_container ${CNAME}
       ;;
    v) #~# Latest version required
       echo -e "\n -${opt} was triggered, No parameter\n" >&2
       VERLOCAL=""
       ;;
    \?) # Error - incorrect option
       echo "Invalid option: -$OPTARG" >&2
       usage_fcn
       exit 1
       ;;
    :) # Missing argument
       echo "Option -$OPTARG requires an argument." >&2
       usage_fcn
       exit 1
       ;;
  esac
done

if [[ ! ${INAME} ]]
    then
        INAME="qmul/centos6_base"
fi

if [[ ! ${HNAME} ]]
    then
        HNAME=${CNAME}
fi

## DEBUGGING ##
exit 0
##

#~# Create container from qmul/${INAME}:${VERLOCAL} image with name ${CNAME}

docker run -d              \
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

echo -e "\n*** The ports for the new conatiner are:\n"
docker port ${CNAME} | sort -n | column -t
echo

