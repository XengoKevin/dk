#!/bin/bash -e

#~# QMUL Fedora 23 Stress container
#
# 2015-12-01 I.Price@qmul.ac.uk : v1.0 Created
# 2015-12-01 I.Price@qmul.ac.uk : Added standard functions

bold=$(tput bold)
normal=$(tput sgr0)

CNAME="chk_f23_app_stress"
INAME="qmul/fedora23_app_stress"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
## Set VERLOCAL to "" to use :latest tag
chk_get_ver
VERLOCAL=":${VER}"
VERLOCAL=""

#~# TODO Hardcoded ports to 3307 2200 8000
R_PORT__MYSQL=3307
R_PORT_SSH=2200
R_PORT_HTTP=8000

#~# Stop old container function
stop_container ${CNAME}

#~# Remove old container function
rm_container ${CNAME}

#~# Create container from qmul/centos6_base:v1.0 image with name chk_f23__app_stress

# Run either -P or the -p options, not both.  -P requires 'EXPOSE 22 80 3306' in Dockerfile
#  -P                       \
#  -p $R_PORT_HTTP:80       \
#  -p $R_PORT_SSH:22        \
#  -p $R_PORT_MYSQL:3306    \

#docker run -d              \
#  -e "TERM=xterm"          \
#  --name=${CNAME}          \
#  --hostname=${CNAME}      \
#  ${INAME}${VERLOCAL}

#  Not used here
#  -P                       \
#  --memory 256M            \
#  --memory-swap 384M       \
#  --cpu-period=50000       \
#  --cpu-quota=25000        \
#  --blkio-weight 500       \
#  --ulimit nproc=1024      \
#  --ulimit core=0          \
#  --ulimit nofile=1024     \
#  --restart unless-stopped \

#echo -e "\n*** The ports for the new conatiner are:\n"
#docker port ${CNAME} | sort -n | column -t
#echo

clear
echo -e "\n${bold}Stress test container tool${normal}\n"
echo -e "\nAn image is available to stress a system by placing load on CPU, Memory,"
echo -e "Disk or IO or a combination of all the parameters."
echo -e "\nThis can be found at dev-centos7-doc-01:/etc/docker_qmul/app/fedora23_app_stress"
echo -e "\nThere is no run.sh script for starting a container due to the multitude of options available."
echo -e "\nA typical run command would be:\n"
echo -e "\n\t${bold}docker run -it --rm  qmul/fedora23_app_stress --cpu 2 --vm 1 --vm-bytes 328M --vm-hang 0${normal}\n"
echo -e "\nThis can be used to test the effects of Docker Runtime constraints on resources"
echo -e "(See Docker SDD: Runtime constraints on resources)\n"
echo -e "\n​\t${bold}docker run -it --rm -m 128m --memory-swap=300m qmul/fedora23_app_stress --vm 1 --vm-bytes 3280M --vm-hang 0${normal}\n"
echo -e "\nThe effects on the system can be monitored using top, htop or systemd-cgtop (SystemD OSs only)"
echo -e "\n\nSee also: http://linux.die.net/man/1/stress"
echo -e "\nSee also: http://people.seas.harvard.edu/~apw/stress/FAQ"


echo -e "\n\n${bold}Usage: stress [OPTION [ARG]] ...${normal}"
echo -e "\n -?, --help         show this help statement"
echo -e "     --version      show version statement"
echo -e " -v, --verbose      be verbose"
echo -e " -q, --quiet        be quiet"
echo -e " -n, --dry-run      show what would have been done"
echo -e " -t, --timeout N    timeout after N seconds"
echo -e "     --backoff N    wait factor of N microseconds before work starts"
echo -e " -c, --cpu N        spawn N workers spinning on sqrt()"
echo -e " -i, --io N         spawn N workers spinning on sync()"
echo -e " -m, --vm N         spawn N workers spinning on malloc()/free()"
echo -e "     --vm-bytes B   malloc B bytes per vm worker (default is 256MB)"
echo -e "     --vm-stride B  touch a byte every B bytes (default is 4096)"
echo -e "     --vm-hang N    sleep N secs before free (default none, 0 is inf)"
echo -e "     --vm-keep      redirty memory instead of freeing and reallocating"
echo -e " -d, --hdd N        spawn N workers spinning on write()/unlink()"
echo -e "     --hdd-bytes B  write B bytes per hdd worker (default is 1GB)"
echo -e "\nExample: stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M --timeout 10s"
echo -e "\nNote: Numbers may be suffixed with s,m,h,d,y (time) or B,K,M,G (size)"
echo
