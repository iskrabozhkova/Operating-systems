#!/bin/bash

if [ $# -lt 1 ];then
    echo "Wrong number of parameters"
    exit
fi
flag=0
if [ $# -eq 2 ];then
    if [ -f $2 ]; then
        flag=1
    else
         echo "not a file"
         exit 2
    fi
fi

broken_symlinks=$(find $1 -xtype l -printf "%f %p\n")
symlinks=$(find $1 -type l -printf "%f->%p\n")
broken_count=$(echo "$symlinks" | wc -l)

if [ $flag -eq 1 ]; then
     while read line; do
        echo "$line" >> "$2"
    done < <(echo "$symlinks")

    if [ -z "$broken_count" ];then
        broken_count=0
    fi

    echo -e "Broken links: $broken_count" >> "$2"
else
    while read line; do
        echo "$line"
    done < <(echo "$symlinks")

    if [ -z "$broken_count" ];then
        broken_count=0
    fi

    echo -e "Broken links: $broken_count"
fi