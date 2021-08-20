#!/bin/bash

if [ ! $# -eq 1 ]; then
    echo "Error! Wrong number of parameters"
fi

notSorted=$(cat "$1" | cut -d '-' -f2-)

i=1
new=$(while read line; do
        echo "$i. $line"
        i=$((i+1))
done < <(echo "$notSorted"))

sorted=$(echo "$new" | sort -t '.' -k2)
echo "$sorted"