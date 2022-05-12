#!/bin/bash

if [ $# -ne 1 ];then
    echo "Wrong number of parameters"
    exit 1
fi
if ! [ -d "$1" ];then
        echo "First parameter is not a directory"
        exit 1
else
        find "$1" -xtype l
fi
