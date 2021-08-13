#!/bin/bash
#TO DO: test it

user_homedirs=$(cat /etc/passwd | grep "/home" | cut -d ":" -f6)
max=0
user=""

while read line; do
    curr_user=$(find "$line" -type f -printf "%u %f %T@" | sort -nr -t ' ' -k2| head -n 1 | awk '{print $1}')
    curr_time=$(find "$line" -type f -printf "%u %f %T@" | sort -nr -t ' ' -k2| head -n 1 | awk '{print $3}')

    if [ "$curr_time" -gt "$max" ];then
        max=$curr_time
        user="$curr_user"
    fi
done < <(echo "$user_homedirs")

echo "$curr_user"