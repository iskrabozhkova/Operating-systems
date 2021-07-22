#!/bin/bash

read -p "Enter filename: " filename
read -p "Enter string: " string
 
grep -q "$string" "$filename"
echo $?

