#!/bin/bash -e

#~# QMUL Standard Docker container creation script
#
# 2016-01-04 I.Price@qmul.ac.uk : Converted to generic run script with parameter files
# 2016-01-05 I.Price@qmul.ac.uk : Added code for taking args & parameters
# 2016-01-07 I.Price@qmul.ac.uk : Removed the NAMES args & parameters & replaced with simple IMAGENAME

#~# Include our standard Bash functions
INC="/etc/docker_qmul/includes"
source ${INC}/dock_func.fcn

# Highlighting
bold=$(tput bold)
normal=$(tput sgr0)

#~# Reset all variables that might be set
CNAME=
HNAME=
NOOUTPUT=
RUN_OPTS=

#~# Print out usage if required
function usage_fcn ()
{
  echo -e "\n\tUsage:\t${0} [-q|--quiet] [-c|--cname] [-h|--hname] [--help]\n"
  echo -e "\n\t\tThis script creates a container using parameter files:"
  echo -e "\n\t\t[-q|--quiet]  Quiet mode - Output container ID only.  Specify as first parameter"
  echo -e "\n\t\t[-c|--cname]  Container name - Required, no spaces"
  echo -e "\n\t\t[-h|--hname]  Host name - Required, no spaces"
  echo -e "\n\t\t[--help]      Show this usage & help"
  echo -e "\n"
}

#~# Process the args and parameters for container & host name
while :; do
    case $1 in
        -\?|--help)            # Call a "Usage" function to display a synopsis, then exit.
            usage_fcn
            exit
            ;;
        -q|--quiet)            # Do not output messages
            NOOUTPUT="No Output"
            ;;
        ## Container Name ##
        -c|--cname)            # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                CNAME=$2
                shift 2
                continue
            else
                if [[ -z ${NOOUTPUT} ]]; then echo -e "\nERROR: \"--cname\" requires a non-empty option argument. See --help.\n" >&2; fi
                exit 10
            fi
            ;;
        ## Host Name ##
        -h|--hname)            # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                HNAME=$2
                shift 2
                continue
            else
                if [[ -z ${NOOUTPUT} ]]; then echo -e "\n${bold}ERROR: \"--hname\" requires a non-empty option argument. See --help.${normal}\n" >&2; fi
                exit 20
            fi
            ;;
        --)                    # End of all options.
            shift
            break
            ;;
        -?*)
            if [[ -z ${NOOUTPUT} ]]; then echo -e "\n${bold}WARNING, QUITTING: Unknown option:\t${1}${normal}\n" >&2; fi
            exit 30
            ;;
        *)                     # Default case: If no more options then break out of the loop.
            break
    esac
    shift
done

#~# Check we have parameters
if [[ -z ${CNAME} ]] || [[ -z ${HNAME} ]]; then
    if [[ -z ${NOOUTPUT} ]]; then echo -e "\n${bold}ERROR, QUITTING: Either container or host name (or both) is not specified${normal}\n" >&2; fi
    usage_fcn
    exit 40
fi

#~# Names cannot contain spaces. Ensure the variables are contiguous.
if [[ ! ${CNAME} = "${CNAME%[[:space:]]*}" ]] || [[ ! ${HNAME} = "${HNAME%[[:space:]]*}" ]]; then
    if [[ -z ${NOOUTPUT} ]]; then
        echo -e "\n${bold}ERROR, QUITTING: Either container or host (or both) has spaces in the name${normal}\n" >&2
        usage_fcn
    fi
    exit 50
fi

#~# Read in the image name from IMAGENAME file and set INAME
read_img_name

#~# Add container & host name to RUN_OPTS
RUN_OPTS="${RUN_OPTS} --name=\"${CNAME}\""
RUN_OPTS="${RUN_OPTS} --hostname=\"${HNAME}\""

#~# Read in parameters from config files
read_params ENV
read_params LABELS
read_params RESOURCES

#~# Check we have a VER from a LABELS file and set VER
chk_get_ver

#~# Check that the version of the image exists
if [[ -z $(docker images -q ${INAME}:${VER}) ]]; then
    if [[ -z ${NOOUTPUT} ]]; then
        echo -e "\n${bold}ERROR, QUITTING: The image ${INAME}:${VER} does not exist.${normal}\n" >&2
        echo -e "\nUse ${bold}docker images${normal} to list images, check the version No. in ${bold}./includes/LABELS${normal} or run ${bold}./build.sh${normal} to create the image.\n" >&2
    fi
    exit 60
fi

#~# Create container
if [[ -z ${NOOUTPUT} ]]; then
    echo -e "\nContainer Name:\t${CNAME}"
    echo -e "\nHost Name:\t${HNAME}"
    echo -e "\nImage Name:\t${INAME}:${VER}"
    echo -e "\nRUN_OPTS:${RUN_OPTS}"
    echo -e "\n"
fi

docker run -d -P ${RUN_OPTS} ${INAME}:${VER}
