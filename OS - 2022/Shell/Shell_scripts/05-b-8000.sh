#!/bin/bash

processes=$(ps -o rss=,vsz= -u "$1" | sort -nr -t ' ' -k2)

while read line; do
    rss=$(echo "${line}" | awk -F ' ' '{print $1}')
    vsz=$(echo "${line}" | awk -F ' ' '{print $2}')
    echo "scale 2; $rss/$vsz" | bc
done < <(echo "${processes}")