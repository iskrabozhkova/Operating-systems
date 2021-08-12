#!/bin/bash

if [ $# -ne 2 ];then
    echo "Wrong number of parameters"
    exit 1
fi

mkdir a
mkdir b
mkdir c

files=$(find . -type f 2>/dev/null)

while read line; do
    line_number=$(cat "$line" | wc -l)
    if [ "$line_number" -lt "$1" ]; then
        mv "$line" a
    elif [ "$line_number" -gt "$1" ] && [ "$line_number" -lt "$2" ]; then
        mv "$line" b
    else
        mv "$line" c
    fi
done < <(echo "$files")