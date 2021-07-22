#!/bin/bash

level=0
max_level=0

line=$(cat "$1" | grep -o . | grep '[{}]')

for i in $line; do 
   if [ $i = '{' ];then
        level=$(($level + 1))
    fi
    if [ $i = '}' ]; then
        if [ $level -gt $max_level ];then
            max_level=$level
        fi
            level=$(($level - 1))
    fi
done

echo $max_level
