#!/bin/bash

if [ $# -ne 2 ];then
    echo "Wrong number of parameters"
    exit 1
fi

sorted=$(cat "$1" | awk -F ',' '{printf "%s,%s,%s\n",$2,$3,$4}' | sort | uniq)

while read line; do

    echo $(cat "$1" | egrep ",$line" | sort -nk 1 | head -n 1) >> "$2"
done < <(echo "$sorted")