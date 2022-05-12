#!/bin/bash

N=10

if [ "$1" = "-n" ];then
    N=$2
fi

F=$(mktemp)

for i in "$@"; do
   if [ $i = "-n" ]
	then
		continue
	fi
	
	if [[ "$i" =~ ^[0-9]+$ ]]
	then
		continue
	fi
    idf=$(echo "$i" | cut -d "." -f1)
    file_content=$(cat "$i" | tail -n "$N")
    
    while read line; do 
        timestamp=$(echo "$line" | cut -d ' ' -f1,2)
        data=$(echo "$line" | cut -d ' ' -f3-)
        echo ""$timestamp" "$idf" "$data"" >> F
    done < <(echo "$file_content")
done

echo "$(cat "$F" |  sort -n -t '-' -k1,1 -k2,2 -k3,3)"
rm "$F"