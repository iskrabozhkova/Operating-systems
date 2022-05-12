#!/bin/bash

home=$(awk -F ':' '{print $6}' /etc/passwd)
F=$(mktemp)

while read line; do
    if [ -d "$line" ];then
        find "$line" -type f -printf "%u %T@\n" 2>/dev/null >> "$F"
    fi
done < <(echo "$home")

cat "$F" | sort -rn -k2 | head -n 1 | awk '{print $1}'