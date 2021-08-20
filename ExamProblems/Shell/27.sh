#!/bin/bash

if [ $# -ne 2 ];then
    echo "Wrong number of parameters"
    exit
fi
if [[ ! -d "$1" ]]; then
    echo "not a directory"
fi

files=$(find $1 -type f -printf "%f\n" | egrep -o "vmlinuz\-[0-9]+\.[0-9]+\.[0-9]+\-$2" | sort -Vr | head -n 1)
echo "$files"

