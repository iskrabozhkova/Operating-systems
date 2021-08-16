#!/bin/bash

if [ $# -ne 1 ];then
    echo "Wrong number of parameters"
    exit 1
fi


name_host=$(cat "$1" | cut -d " " -f2 | sort | uniq)
while read line; do
   http=$(cat "$1" | grep "$line" | grep "HTTP/2.0" | wc -l)
  no_http=$(cat "$1" | grep "$line" | grep -v "HTTP/2.0" | wc -l)
  echo "$line g HTTP/2.0: $http non-HTTP/2.0: $no_http"
done < <(echo "$name_host")

address=$(cat "$1" | cut -d " " -f1 | sort | uniq)

while read line; do
    code=$(cat "$1" | grep "$line" | cut -d " " -f9)
    while read codes; do
         if (( "$codes" > 302 )) ; then
          echo "$line $codes" >> file.txt
         fi
    done < <(echo "$code")
done < <(echo "$address")

echo "$(cat "file.txt" | sort -nr -k2 | uniq -c | head -n 2)"
