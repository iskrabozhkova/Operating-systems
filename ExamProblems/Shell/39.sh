#!/bin/bash

if [ $# -ne 3 ];then
    echo "Wrong number of parameters"
    exit 1
fi

files=$(find $3 -type f -name "*.cfg")

while read line; do
    cat "$line" | egrep "[{ no-production }; | { volatile }; | { run\-all; };]"
    if [ $? -eq 0 ]; then
        cat "$line" >> "$2"
    fi
done < <(echo "$files")
