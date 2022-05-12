#!/bin/bash

option="$1"

if [ ! $# -eq 2 ];then
    echo "Error! Wrong number of parameters"
    exit 1
fi
if [ "$option" == '-r' ]; then
    echo -e "\033[0;31m "${2}""
elif [  "$option" == '-g' ]; then
    echo -e "\033[0;32m "${2}""
elif [  "$option" == '-b' ]; then
    echo -e "\033[0;34m "${2}""
else 
    echo "Unknown color"
fi

echo '\033[0m'