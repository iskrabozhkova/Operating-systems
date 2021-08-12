#!/bin/bash

if [ $# -ne 2 ];then
    echo "Wrong number of parameters"
    exit
fi

first_lines=$(cat "$1" | wc -l)
second_lines=$(cat "$2" | wc -l)

if [ $first_lines -gt $second_lines ];then
    cat "$1" | cut -d "-" -f2,3 | sort >> "$1".songs
else
    cat "$2" | cut -d "-" -f2,3 | sort >> "$2".songs
fi