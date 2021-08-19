#!/bin/bash

 if [[ ! "$(whoami)" == "root" ]];then
 	echo "Not root"
 	exit 1
 fi

users=$(users)

while read line; do
    rss=$(ps -u "$line" -o user=,pid=,rss= | awk 'BEGIN{COUNT=0} {COUNT+=$3} END{print COUNT}')
    echo "$rss"
    process_num=$(ps -u "$line" -o user=,pid=,rss= | wc -l)
    avg=$(("$rss"/"$process_num"))

    max_rss=$(ps -u "$line" -o user=,pid=,rss= | sort -nrk 3 | head -n 1 | tr -s " " | cut -d " " -f3)
    max_pid=$(ps -u "$line" -o user=,pid=,rss= | sort -nrk 3 | head -n 1 | tr -s " " | cut -d " " -f2)
    

    if [ "$max_rss" -eq $((avg * 2)) ]; then
        echo "$max_pid"
    fi

done < <(echo "$users")
