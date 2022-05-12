#!/bin/bash

output=$2
touch "$output"

input_size=$(stat -c "%s" "$1")
arrN=$((input_size/2))
echo "include <stdint.h>" >> "$ouput"
echo "uint32_t arrN="$arrN""

xxd "$1" | cut -d ' ' -f1-8 
