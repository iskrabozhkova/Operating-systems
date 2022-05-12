#!/bin/bash

F=$(mktemp)

ps -e -o pid=,uid=,rss= | sort -k2,2n -k3,3n > $F

for u in $(awk '{print $2}' $F | sort | uniq);do
    read s m < <(awk -v "foo=$u" '$2==foo {s+=$3;m=$1}END {print s,m}')
    echo "$u $s"
    if [ $s -gt $max ];then
        kill $m
        sleep 2
        kill -9 $max
    fi
done 