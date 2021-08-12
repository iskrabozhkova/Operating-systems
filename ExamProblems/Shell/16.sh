#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Wrong number of arguments"
    exit 1
fi

if [[ ! "$1" =~ ^[0-9]+$ ]]; then
    echo "Not a number"
    exit 1
fi

if [ "$(whoami)" == "root" ]; then
    user=$(users)

    while read line;do
        size=$(ps -u "$line" -o uid=,pid=,rss= | awk 'BEGIN{COUNT=0} {(COUNT+=$3)} END {print COUNT}')
        if [ "$size" -gt "$1" ];then
            pid=$(ps -u "$line" -o uid=,pid=,rss= | sort -nr -k2 | head -n 1 | awk '{print $2}')
            echo "$pid"
        fi
    done < <(echo "$user")
else
    echo "Not a root"
fi
