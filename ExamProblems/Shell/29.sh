#!/bin/bash

if [ $# -ne 1 ];then
    echo "Wrong number of parameters"
    exit
fi

friends=$(find "$1" -mindepth 3 -maxdepth 3 -type d -printf "%p\n")
count=0
while read line; do
    matched_friend=$(echo "$friends"| grep "$line")
    for i in "$matched_friend"; do
        result=$(find "$i" -type f 2>/dev/null | egrep "[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}.txt" | cut -d "/" -f5)
     
        while read file; do
    #problem with cat
            current=$(cat "${file}" | wc -l)
            count=$((count+"$current"))
        done < <(echo "$result")
        echo "$file:$count" >> helpFile.txt
    done
done < <(echo "$friends")

echo "$(cat helpFile.txt | sort -nr -t ":" -k2 | head -n 1 | cut -d ":" -f1)"