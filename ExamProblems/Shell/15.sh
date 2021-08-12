#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Wrong number of parameters!"
fi

if [ ! -d "$1" ];then
    echo "Not a directory"
fi

find "$1" -xtype l