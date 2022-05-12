#!/bin/bash

option="$1"

if [ ! $# -eq 1 ]; then
    echo "Wrong number of parameters"
    exit 1
fi

flag=0
if [ "${option}" == "-r" ];then
    flag=1
elif [ "${option}" == "-g" ];then
    flag=2
elif [ "${option}" == "-b" ];then
    flag=3
elif [ "${option}" == "-x" ];then
    flag=4
fi

if [ "$flag" -lt 4 ];then
    while read line; do
         if [ "$flag" -eq 1 ];then
             echo -e "\033[0;31m "${line}""
         elif [ "$flag" -eq 2 ];then
             echo -e "\033[0;32m "${line}""
         elif [ "$flag" -eq 3 ];then
             echo -e "\033[0;34m "${line}""
             flag=0
         fi
         flag=$(($flag+1))
    done
else
    while read line; do
        echo -e "$line"
    done
fi

echo -e "\033[0m";