#!/bin/bash

if [ $# -gt 2 ];then
    echo "Wrong number of parameters"
    exit 1
fi

destionation=0

if [ $# -eq 1 ]; then
    destination=$(date)
    mkdir "$destination"
else
    if [ ! -d "$2" ];then
        echo "Second parameter is not a directory"
        exit 1
    else
        destination=$2
    fi
fi
if [ ! -d "$1" ];then
    echo "First parameter is not a directory"
    exit 1
fi

files=$(find "$1" -mindepth 1 -type f -ctime -45 -printf "%p %f\n" 2>/dev/null)

while read line; do
    path=$(echo "$line" | cut -d ' ' -f1)
    filename=$(echo "$line" | cut -d ' ' -f2)
    cp "$path" "$destination"/"$filename"
done < <(echo "$files")