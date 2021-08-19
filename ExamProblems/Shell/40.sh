#!/bin/bash

if [ $# -ne 3 ];then
    echo "Wrong number of parameters"
    exit 1
fi


searched=$(cat "$1" | grep "$2")
echo "$searched"
if [ $? -eq 0 ]; then
     while read search; do
         while read line; do
             if [ "$line" != "$search" ]; then
                 echo "$line" >> help.txt
             else 
                 echo -e "# $line #edited at $(date) by $(whoami)\n"$2"="$3"" >>help.txt
             fi    
         done < <(cat "$1") 
     done < <(echo "$searched")
else 
    while read line; do
         echo "$line" >> help.txt  
    done < <(cat "$1") 
    echo ""$2"="$3"" >> help.txt
fi
cat help.txt > file.txt
    
