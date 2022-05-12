#!/bin/bash

number=$1
prefix=$2
unit=$3

decimal=$(grep "$prefix" prefix.csv | awk -F ',' '{print $3}'| sed 's/\r$//')
multiply=$(echo "$number*$decimal" | bc)

#grep s - reda i izvejdam