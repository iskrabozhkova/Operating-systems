#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Wrong number of parameters"
    exit 1
fi
if ! [ -f "$1" ]; then
    echo "First argument is not a file"
    exit 1
fi
if ! [ -d "$2" ];then
    echo "Second argument is not a directory"
    exit 1
fi

file=$1
dir=$2
F=$(mktemp)

while read line; do
    sed -E "s/(^[a-zA-Z]+\s+[a-zA-Z]+)(\s\(.+\):)/\1:/" "$line" >> "$F"
done < <(echo "$file")

final=$(cat "$F" | cut -d ':' -f1 | sort | uniq)
number=0

while read line; do
    echo ""$line";"$number"" >> ""$dir"/dict.txt"
    number=$(($number + 1))
done < <(echo "$final")

dict_content=$(cat ""$dir"/dict.txt")

while read line; do
    name=$(echo "$line" | cut -d ';' -f1)
    num=$(echo "$line" | cut -d ';' -f2)
    grep "$name" "$file" >> ""$dir"/$num.txt"
done < <(echo "$dict_content")

rm "$F"
rm ""$dir"/dict.txt"