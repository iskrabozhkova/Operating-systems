#!/bin/bash

if [ ! $# -eq 2 ];then
    echo "Wrong number of parameters"
    exit 1
fi
if [ ! -d "$1" ];then
    echo "First parameter is not a directory"
    exit 1
fi
if [ ! -f "$2" ];then
    echo "Second parameter is not a file"
    exit 1
fi

files=$(find "${1}" -type f)

while read line; do
    cmp -s "${line}" "${2}"
    if [ $? -eq 0 ] && [ "$(stat -c "%i" "$line")" != "$(stat -c "%i" "$2")" ];then
        echo "${line}"
        fi
done < <(echo "${files}")

