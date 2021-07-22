#!/bin/bash

if [ $# - eq 2 ];then
    copy_dir=$2
elif [ $# -eq 1 ];then
    copy_dir=$(date)
else
    echo "Wrong number of parameters"
fi

find "$1" -type f -mmin 45 -exec cp {} "$copy_dir" \;