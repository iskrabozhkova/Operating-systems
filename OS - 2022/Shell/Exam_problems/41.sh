#!/bin/bash

file=$1
cat_file=$(cat "$file")

while read line; do
if ! $(echo "$line" | egrep -q "^#.*");then
    line_no_spaces=$(echo "$line" | sed 's/ //g')
    key=$(echo "$line_no_spaces" | cut -d "=" -f1)
    value=$(echo "$line_no_spaces" | cut -d "=" -f2)
    date=$(date)
    user=$(whoami)
    if [ "$key" == "$2" ] && [ "$value" != "$3" ];then
        sed -i "s/$line/#$line #edited at $date by $user/" "$file"
        sed -i "s/#$line #edited at $date by $user/a "$2"="$3"  #added at "$date" by "$user"\n" 
    else
        echo ""$2" = "$3" #added at "$date" by "$user"" >> "$file"
    fi
fi
done < <(echo "$cat_file")
