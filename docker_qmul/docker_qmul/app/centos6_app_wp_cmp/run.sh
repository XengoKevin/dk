#!/bin/bash -e 

#~# QMUL CentOS 6 Custom Application LAMP container
#
# Log:
# 2015-11-24 I.Price@qmul.ac.uk : v1.0 Created

#INAME="centos6_apache"
CNAME="centos6appwpcmp"
# VER=":v1.0"
# This assumes 'latest' image exists until we have a VCS
VER=""

#~# TODO Hardcoded ports to 3307 2200 8000
R_PORT__MYSQL=3307
R_PORT_SSH=2200
R_PORT_HTTP=8000

#~# Stop old container
if [[ $(docker ps -f name="${CNAME}" --format "{{.ID}}") ]] ; 
    then 
        echo -e "\n*** Stopping old ${CNAME} ***\n"
        docker stop $(docker ps -f name="${CNAME}" --format "{{.ID}}") ; 
    else 
        echo "No container to stop" ; 
fi

#~# Remove old container
#~# TODO : Need to ask user if they really mean this
if [[ $(docker ps -a -f name="${CNAME}" --format "{{.ID}}") ]] ; 
    then 
        echo -e "\n*** Removing old ${CNAME} ***\n"
        docker rmi $(docker ps -a -f name="${CNAME}" --format "{{.ID}}") ; 
    else 
        echo "No container to remove" ; 
fi

#~# Create pod of containers - see docker-copose.yml for images used
# docker-compose takes care of all the names
docker-compose up -d

