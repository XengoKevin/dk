#~# QMUL CentOS 6 Custom Application LAMP container with Puppet
#
# Log:
# 2015-11-20 martin: v1.0 Created
# 2015-12-03 I.Price@qmul.ca.uk : Updated build tags and turned comments into Usage
# 2015-12-03 I.Price@qmul.ca.uk : Added standard function calls
# 2015-12-04 I.Price@qmul.ca.uk : Added Resource limits & ulimits

if [[ -z $1 ]]
    then
        CNAME="chk_c6_app_lamp_puppet"
    else
        CNAME=${1}
fi
INAME="qmul/centos6_app_lamp_puppet"

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

#~# Check we have a VER from a VERSION file
## Set VERLOCAL to "" to use :latest tag
chk_get_ver
VERLOCAL=":${VER}"
VERLOCAL=""

#~# TODO Hardcoded ports to 3308 2201 8001
R_PORT__MYSQL=3308
R_PORT_SSH=2201
R_PORT_HTTP=8001

#~# Stop old container
stop_container ${CNAME}

#~# Remove old container
#~# TODO : Need to ask user if they really mean this
rm_container ${CNAME}

#~# Run the postinstall configuration (join to puppet and update)

cat <<EOF

Please add the following line to the QM Puppet main manifest in the Containers section.

node ${CNAME} inherits containernode { }

Please also sign the certificate request

Press N and ask Martin if you dont know what this means.

Enter Y when done any other char to exit.
EOF

read input
if [ "$input" != "Y" ];
then
   echo Exiting.
   exit 1
fi


#~# Create container from qmul/centos6_app_lamp_puppet:${VER} image with name chk_c6_app_lamp_puppet

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
  --blkio-weight 500       \
  --ulimit nproc=1024      \
  --ulimit core=0          \
  --ulimit nofile=1024     \
  --name=${CNAME}          \
  --hostname=${CNAME}      \
  --restart unless-stopped \
  ${INAME}${VERLOCAL}

echo -e "\n*** The ports for the new conatiner are:\n"
docker port ${CNAME} | sort -n | column -t
echo

#~# Add the puppet server to the hosts file
# This must be done here not at Dockerfile level as docker overwrites it
docker exec -i ${CNAME} sh -c 'echo 10.16.240.104 puppet puppet.localdomain >>/etc/hosts'

#~# Run the puppet agent to setup our users
docker exec -i ${CNAME} puppet agent -t --waitforcert

