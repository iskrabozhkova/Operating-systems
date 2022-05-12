#!/bin/bash

src=$1

files=$(find "$src" -mindepth 1 -type f 2>/dev/null)
dst=$(mktemp -d)

while read line; do
    cleared=$(echo "$line" | sed 's/^ *//g' | sed 's/[ \t]*$//')
    title=$(echo "$cleared" |  sed -e 's/(.*)//g' | tr -s ' ' | cut -d '.' -f1)
    album=$(echo "$cleared")
    hash=$(echo "$cleared" | sha256sum | cut -c 1-16)
done < <(echo "$files")