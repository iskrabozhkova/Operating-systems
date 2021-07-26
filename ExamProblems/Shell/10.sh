#!/bin/bash

type_of_farest=$(cat "file.txt" | tail -n +2 | sort -nr -t ';' -k3 | head -n 1 | cut -d ';' -f2)
searched=$(cat "file.txt" | tail -n +2 | egrep "^[^;]*;$type_of_farest" | sort -n -t ';' -k3 | head -n 1 | awk -F ';' '{print $1"\t"$4}')

echo "$searched"