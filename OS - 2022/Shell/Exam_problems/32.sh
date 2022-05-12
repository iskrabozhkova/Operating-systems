#!/bin/bash

source=$1
dest=$2
#ne raboti a bi trqbvalo -?
sort -t ',' -k2 -k1,1n "$source" | sed 's/,/\t/g' | uniq -f 1 | tr '\t' ',' >> "$dest"