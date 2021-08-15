#!/bin/bash

if [ $# -ne 2 ];then
    echo "Wrong number of parameters"
    exit 1
fi

touch dict.txt "$2"

names=$(cat "$1" |  egrep -o "^[a-zA-Z]+\s+[a-zA-Z]+" | sort | uniq)
counter=1
while read line; do
    name=$(echo "$line" | egrep -o "^[a-zA-Z]+\s+[a-zA-Z]+")
    echo ""$name":"$counter"" >> dict.txt
    touch "$counter".txt "$2"
    echo "$(cat "$1" | grep "$name" | cut -d ":" -f2)" >> "$counter".txt
    counter=$((counter + 1))

done < <(echo "$names")





