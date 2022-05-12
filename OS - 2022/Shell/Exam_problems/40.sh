#!/bin/bash

files=$(find "$3" -mindepth 1 -type f -name "*.cfg" 2>/dev/null)
F=$(mktemp)

while read file; do
    cat_file=$(cat "$file")
     isValid=1
     row=1
    while read line; do
    echo "$line" | egrep "^{[^{}]+};"
        if !  $(echo "$line" | egrep -q "^{.+};") && ! $(echo "$line" | egrep -q "^#.*"); then
            if [ "$isValid" -eq 1 ]; then
                echo "Error in "$file"" >> "$F"
            fi
           isValid=0
            echo "Line "$row": "$line"" >> "$F"
        fi
        row=$(($row + 1))
    done < <(echo "$cat_file")

    if [ "$isValid" -eq 1 ]; then
        echo "$cat_file" >> "$2"
        username=$(echo "$file" | cut -d '.' -f1)
        if ! $(cat "$2" | egrep "$username"); then
            password=$(pwgen 16 1)
            echo "$username" "$password" >> "$2"
            echo "$username" "$password"
        fi
    fi
done < <(echo "$files")

echo "File: "
cat "$F"