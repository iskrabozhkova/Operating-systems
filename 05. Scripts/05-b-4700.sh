#!/bin/bash


if [[ ! $1 =~ ^[0-9]+$ ]]; then
	echo "Error!This is not a number"
	exit 1
fi
if [ $# -eq 1 ]; then
	$2=" "
fi
rev_num=$(echo $1 | rev)
echo $(echo $rev_num | sed -E "s/(.{3})/\1$2/g" | rev)
exit 0