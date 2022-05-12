#!/bin/bash

cfgdir="$3"
files=$(find "$cfgdir" -midepth 1 -type f -name "*.cgf" 2>/dev/null)

for i in "$files"; do
    echo "$i"
done 