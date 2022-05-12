#!/bin/bash

if [ $# -ne 2 ];then
    echo "Wrong number of parameters"
    exit 1
fi
if ! [ -f "$1" ];then
    echo "First is not a file"
    exit 1
fi
if ! [ -f "$2" ];then
    echo "Second is not a file"
    exit 1
fi

file1=$1
file2=$2

file1_lines=$(cat "$file1" | wc -l)
file2_lines=$(cat "$file2" | wc -l)

if [ "$file1_lines" -gt "$file2_lines" ];then
    cat "$file1" |  awk -F '-' '{print $2 "-" $3}' | sort | sed 's/ //' >> "$file1".txt
else 
    cat "$file2" |  awk -F '-' '{print $2 "-" $3}' | sort | sed 's/ //' >> "$file2".txt
fi