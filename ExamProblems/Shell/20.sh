#!/bin/bash

if [ $# -ne 3 ];then
    echo "Wrong number of parameters"
    exit
fi

first_set=$(cat "$1" | egrep "^$2=" | cut -d "=" -f2)
second_set=$(cat "$1" | egrep "^$3=" | cut -d "=" -f2)

while read line; do
		for i in $line; do
			second_set=$(echo $second_set | sed -E "s/$i//")
		done
done < <(echo "$first_set")

result=$(cat "$1" | sed -E "s/^$3=.*/$3=$second_set/")

echo "$result" > "$1"