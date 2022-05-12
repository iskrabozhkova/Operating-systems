#!/bin/bash

if [ $# -ne 1 ];then
    echo "Wrong number of parameters"
    exit 1
fi
if [ -d "$1" ];then
    echo "The argument is not a file"
    exit
fi
file=$1
top_sites=$(cat "$file" | cut -d '-' -f1 | sort | uniq -c | sort -nr -k 1 -t ' ' | head -n 3 | tr -s ' ' | sed 's/ //' | cut -d ' ' -f3)

while read line; do
    http=$(cat "$file" | grep "$line" | grep "HTTP/2.0" | wc -l)
    no_http=$(cat "$file" | grep "$line" | grep -v "HTTP/2.0" | wc -l)
    site_name=$(echo "$line" | cut -d ' ' -f2)
    echo ""$site_name" HTTP/2.0: "$http" non-HTTP/2.0: "$no_http""
done < <(echo "$top_sites")

address=$(cat "$1" | cut -d " " -f1 | sort | uniq)
F=$(mktemp)
while read line; do
    #not so true
    code=$(cat "$file" | grep "$line" | cut -d ' ' -f9)
    if [ "$code" > 302 ];then
        echo "$line" >> "$F"
    fi
done < <(echo "$address")

cat "$F" | sort | uniq -c | head -n 5

rm "$F"


