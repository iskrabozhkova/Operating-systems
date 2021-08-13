#!/bin/bash

#a)
if [ $# -eq 1 ] || [ $# -eq 2 ];then
    files=$(find "$1" -type f -printf "%f %n\n" )
    while read line; do
        harlinks_number=$(echo "$line" | awk '{print $2}')
        filename=$(echo "$line" | awk '{print $1}')
        if [ $harlinks_number -ge "$2" ]; then
            echo "$filename"
        fi
    done < <(echo "$files")
else
    echo "Wrong number of parameters"
    exit 1
fi