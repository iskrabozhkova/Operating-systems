#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo "You have to be root user"
    exit 1
fi

users=$(cat "/etc/passwd")

while read line;do
    current_dir=$(echo "$line" | cut -d ":" -f6)
    current_user=$(echo "$line" | cut -d ":" -f1)
    if [ -d "$current_dir" ]; then
        echo "$current_user"
    fi
    if [ -w "$current_dir" ]; then
        echo "$current_user"
    fi

done < <(echo "$users")