#!/bin/bash
#not working

file1=$(mktemp)
while read -r line; do
    
if [ $(echo "$line" | egrep -c "^-?[0-9]+$") -ne 0 ] ;then
     echo "$line" >> file1
fi
max_num=$(cat "$file1" | sed "s/-//" | sort -n | tail -n 1)
result=$(cat "$file1" | grep "$max_num")
echo "$result"
done 

rm "$file1"



