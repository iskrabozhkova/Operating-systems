#!/bin/bash
N=10

if [ "$1" = "-n" ];then
    N=$2
fi
for i in "$@"; do
    if [ $i = "-n" ]
	then
		continue
	fi
	
	if [[ "$i" =~ ^[0-9]+$ ]]
	then
		continue
	fi

    echo "N: $N"
    echo "i: "$i""
    id=$(echo "$i" | cut -d '.' -f2)
    lines_to_read=$(cat "$i" | tail -n "$N")

    while read line; do 
        timestamp=$(echo "$line" | cut -d ' ' -f1,2)
        data=$(echo "$line" | cut -d ' ' -f3-)
        echo ""$timestamp" "$id" "$data""
    done < <(cat "$lines_to_read")
done