#!/bin/bash


binary_name="/.mbr/mbr -v"
latest_version=$1
binary_url="https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-$1"

if  [ command -v $binary_name &> /dev/null ]
then
    # Binary doesn't exist
    echo "Downloading Juicy binary"
    wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-$1 -O /.mbr/mbr
    chmod +x  /.mbr/mbr
    echo "$(date) - Juicy updated - $(eval $binary_name)"
else
    # Binary exists, check version
    current_version=$($binary_name | cut -d ' ' -f 3)
    if [[ "$current_version" != "$latest_version" ]]
    then
        echo "Downloading $binary_name $latest_version"
        wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-$1 -O /.mbr/mbr
        chmod +x  /.mbr/mbr
        echo "$(date) - Juicy updated - $(eval $binary_name)"
    else
        echo "$(date) - Juicy is up to date"
    fi
fi
