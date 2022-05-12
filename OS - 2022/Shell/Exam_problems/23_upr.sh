#!/bin/bash

while read U H; do
    if [ -d ${H} ];then
        find $H -type f -printf "$U %T@ %p\n"
    fi
done < <(awk -F ':' '{print $1 $6}' /etc/passwd | sort -rn -k2,2 | head -n 1 | awk '{print $1 $3}')