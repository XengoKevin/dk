#!/bin/sh

#~# Script to process the arguements & parameters for container & host name

# Highlighting
bold=$(tput bold)
normal=$(tput sgr0)

# Reset all variables that might be set
CNAME=
HNAME=
NOOUTPUT=

function usage_fcn ()
{
  echo -e "\n\tUsage:\t${0} [-q|--quiet] [-c|--cname] [-h|--hostname]\n"
  echo -e "\n\t\tThis script creates a container using pararmeter files:"
  echo -e "\n\t\t[-q|--quiet]  Quiet mode - No output.  Specify as first parameter"
  echo -e "\n\t\t[-c|--cname]  Container name - Required, no spaces"
  echo -e "\n\t\t[-h|--hname]  Host name - Required, no spaces"
  echo -e "\n"
}

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
        -c=?*|--cname=?*)
            CNAME=${1#*=}      # Delete everything up to "=" and assign the remainder.
            ;;
        -c=|--cname=)          # Handle the case of an empty --file=
             if [[ -z ${NOOUTPUT} ]]; then echo -e "\nERROR: \"--cname\" requires a non-empty option argument. See --help.\n" >&2; fi
            exit 20
            ;;
        ## Host Name ##
        -h|--hname)            # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                HNAME=$2
                shift 2
                continue
            else
                if [[ -z ${NOOUTPUT} ]]; then echo -e "\nERROR: \"--hname\" requires a non-empty option argument. See --help.\n" >&2; fi
                exit 30
            fi
            ;;
        -h=?*|--hname=?*)
            HNAME=${1#*=}      # Delete everything up to "=" and assign the remainder.
            ;;
        -h=|--hname=)          # Handle the case of an empty --file=
            if [[ -z ${NOOUTPUT} ]]; then echo -e "\nERROR: \"--hname\" requires a non-empty option argument. See --help.\n" >&2; fi
            exit 40
            ;;
        --)                    # End of all options.
            shift
            break
            ;;
        -?*)
            if [[ -z ${NOOUTPUT} ]]; then echo -e "\nWARN: Unknown option (ignored):\t${1}" >&2; fi
            ;;
        *)                     # Default case: If no more options then break out of the loop.
            break
    esac
    shift
done

# --CNAME is a required option. Ensure the variable "CNAME" has been set and exit if not.
if [[ -z ${CNAME} ]]; then
    if [[ -z ${NOOUTPUT} ]]; then
        echo -e "\n${bold}ERROR: option \"--cname CONTAINER_NAME\" not given.${normal}\n" >&2
        usage_fcn
    fi
    exit 50
fi

# --CNAME cannot contain spaces. Ensure the variable "CNAME" is contiguous.
if [[ ! ${CNAME} = "${CNAME%[[:space:]]*}" ]]; then
    if [[ -z ${NOOUTPUT} ]]; then
        echo -e "\n${bold}ERROR: option \"--cname CONTAINER_NAME\" has spaces in the name.${normal}\n" >&2
        usage_fcn
    fi
    exit 55
fi

# --HNAME is a required option. Ensure the variable "HNAME" has been set and exit if not.
if [[ -z ${HNAME} ]]; then
    if [[ -z ${NOOUTPUT} ]]; then
        echo -e "\n${bold}ERROR: option \"--hname HOST_NAME\" not given.${normal}\n" >&2
        usage_fcn
    fi
    exit 60
fi

# --HNAME cannot contain spaces. Ensure the variable "HNAME" is contiguous.
if [[ ! ${HNAME} = "${HNAME%[[:space:]]*}" ]]; then
    if [[ -z ${NOOUTPUT} ]]; then
        echo -e "\n${bold}ERROR: option \"--hname HOSTNAME\" has spaces in the name.${normal}\n" >&2
        usage_fcn
    fi
    exit 65
fi

# Rest of the program here
if [[ -z ${NOOUTPUT} ]]; then
    echo -e "\nCNAME: ${CNAME}"
    echo -e "\nHNAME: ${HNAME}"
    echo -e "\n"
fi
exit 0
