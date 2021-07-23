#!/bin/bash

read -p "Enter string: " string
for i in "$@"; do 
    num_lines=$(cat "$i" | grep "$string" | wc -l)
    echo "$num_lines"
done