#!/bin/bash

if [ $# -ne 1 ];then
    echo "Wrong number of parameters"
    exit
fi

process_count=$(ps -u "$1" -e -uid=,rss= | wc -l)
users=$(users)
user_time=0

for i in "$users"; do
    curr_user_process_count=$(ps -u "$i" -e -uid=,rss= | wc -l)
    if [ curr_user_process_count -gt process_count ]; then
        echo "$i"
    fi
    user_time=$(ps -u "$i" -e -uid=,rss=,time= | awk 'BEGIN{COUNT=0}{(COUNT+=$3)} END{print COUNT}')
done

echo "$user_time"

# if [ $(ps -u "$1" -e -uid=,rss=,time= | awk '{print $3}') -gt "$user_time" ]; then
#     #kill process
#     echo ""
# fi
