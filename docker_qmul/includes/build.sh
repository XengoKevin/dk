#!/bin/bash -e

#~# Test build.sh script to check out functions and other scripts

CNAME="chk_base"
#CNAME="voltest"
INAME="qmul/centos6_base"
INCS=""
source ./dock_func.fcn

chk_get_ver

#echo ${VER}

unique_ver ${INAME} ${VER}

exit

