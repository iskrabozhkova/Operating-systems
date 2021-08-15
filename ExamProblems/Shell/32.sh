#!/bin/bash

#a)

numbers=$(cat file.txt | sort | uniq | egrep "^-?[0-9]+$")
max=0
while read line; do 
    absolute=$(echo "$line" | sed "s/^-//")
    if [ "$absolute" -gt "$max" ];then
        max="$absolute"
    fi
done < <(echo "$numbers")

while read number; do
    if [ $(echo "$number" | sed "s/^-//") -eq "$max" ];then
        echo "$number"
    fi
done < <(echo "$numbers")
