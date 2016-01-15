#~# Script to auto increment the version number

VER_FILE="LABELS"
# Read entire file into an array so we can play with original
readarray -t LABELS_FILE < ${VER_FILE}

#~# Get version No. & strip 'v' and quotes
#~# TODO We should be able to do an inline replacement but couldn't get the count to increment
count=$( awk -F'version=' '{print$2}' ${VER_FILE} | sed 's/v\|"//g')

## This line is a working sed cmd that works with/without quotes to produce Ver_No.
## basis of the inline replacement
#sed -r 's:(--label version=)(")*(v)([0-9][0-9]*):\1\2\3(\4):' testtext

#~# Remove old labels file and create empty replacement
#~# TODO Change this to happen only after successful creation of new parameters
rm -f ${VER_FILE}; touch ${VER_FILE}

for LINE in "${LABELS_FILE[@]}"
do
    if [[ $( echo ${LINE} | egrep "label version" ) ]]; then
        # Add new version No. to new ${VER_FILE}
        # The 10# removes leading zeros by converting to base 10
        printf "%s%04d\"\n" "--label version=\"v" "$((10#$count+1))" >> ${VER_FILE}
    else
        # Otherwise just copy verbaitum the line to new ${VER_FILE}
        echo -e "${LINE}" >> ${VER_FILE}
    fi
done
