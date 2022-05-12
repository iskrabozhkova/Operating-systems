#!/bin/bash

if [ ! $# -eq 2 ];then
        echo "Wrong number of parameters"
        exit 1
fi
if [ ! -d "${1}" ];then
        echo "${1} is not a directory"
        exit 1
fi
if [ ! -d "${2}" ];then
        echo "${2} is not a directory"
        exit 1
fi

extensions=$(find "$1" -type f -printf "%f\n" 2>/dev/null |grep  '\.' | sed 's/^[^.]*\.//g' | sort | uniq)
files=$(find "$1" -type f -printf "%p\n" 2>/dev/null)

while read line; do
        mkdir -p "$2"/"${line}"
done < <(echo "${extensions}")

while read file; do
        file_ext=$(basename "${file}" | grep  '\.' | sed 's/^[^.]*\.//g' | sort | uniq)
        basename=$(basename "${file}")
        cp "${file}" "${2}/${file_ext}/${basename}"
done < <(echo "${files}")
