#!/bin/bash

if [ ! $# -eq 2 ];then
        echo "Wrong number of parameters"
        exit 1
fi
if [ ! -d "$1" ];then
    echo "First argument is not a directory"
    exit 1
fi
if [[ ! "${2}" =~ ^[0-9]+$ ]];then
    echo "Second argument is not a number"
    exit 1
fi

files=$(find "$1" -mindepth 1 -type f -size +"$2" 2>/dev/null)

echo "$files"