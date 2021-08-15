#!/bin/bash

if [ $# -ne 1 ];then
    echo "Wrong number of parameters"
    exit 1
fi

#TO DO: for newest modified
files=$(find "$1" -type f -printf "%p %T\n" 2>/dev/null | grep ".tgz" | egrep "[^_]+_report-[0-9\.]+\.tgz" | sort -nrk 2 | head -n 1| cut -d " " -f1)


