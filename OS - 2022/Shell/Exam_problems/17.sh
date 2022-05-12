#!/bin/bash

users=$(cat /etc/passwd)

while read line; do
    dir=$(echo "$line" | cut -d ':' -f6)
    username=$(echo "$line" | cut -d ':' -f1)

    if [ -z "$line" ];do
        echo "Empty field - no diractory."
        exit 1
    elif ! [ -d "$line" ]; then
        echo "This is not a directory"
        exit 1
    else 
        info=$(stat -c "%a %u %g" "dir")
        #ako vsichki imat write acccess
        # grupata ima write, ownera v grupata li e?
        # ownera ima write, usera owner li e na directoriqta?
        if $(stat -c "%a" afile.txt | grep ".[67]."); then

        if [ "$(stat -c "$u" "$dir")" != "$username" ];then
            echo "User is not owner if diractory"
        elif []


done < <(echo "$users")