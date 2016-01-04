#!/bin/bash

#~# QMUL Debian 8 Wordpress Application image
#~# Script to build wordpress docker images pod from offical latest images
#~# TODO: Convert images & scripts to QMUL standard images
#~# Based on dockerhub.io scripts
#
# 2015-11-20 I.Price@qmul.ac.uk: v1.0 Created

CURDIR=$(pwd); clear; echo $CURDIR
TAG="qmul/"${CURDIR##*/}; echo; echo $TAG; echo

usage() { echo -e "Usage: $0 -n <Web Site Name>\n" 1>&2; exit 1; }

while getopts ":n:" o; do
    case "${o}" in
        n)
            WEBNAME="${OPTARG}"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${WEBNAME}" ]; then
    usage
fi

echo -e "${WEBNAME}\n"

#~# The build file emulates the cmd line process:

#~# Create the data volume container with name ${WEBNAME}_wp_data
docker run -v /var/lib/mysql -v /var/www/html --name ${WEBNAME}_wp_data -d busybox echo 'WP Data Vol'

#~# Create the MySQL container with name ${WEBNAME}_wp_mysql linked to data volume
docker run --name ${WEBNAME}_wp_mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw --volumes-from ${WEBNAME}_wp_data -d mysql

#~# Create the Wordpress container with name ${WEBNAME}_wp linked to the MySQL container
ID=$(docker run --name ${WEBNAME}_wp --link=${WEBNAME}_wp_mysql:mysql -P -d wordpress)
echo -e "${ID}\n"

#~# Display ports allocated
PORTID=$(docker port ${ID}) 
echo -e "\nPort for instance wp_${WEBNAME} is ${PORTID}\n"

docker ps -a
echo
