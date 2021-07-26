#!/bin/bash

echo$(cat file.txt | grep "/home/Inf" | egrep "[a-z0-9]{6}:x:[0-9]{4}:[0-9]{3}:[^ ]+ [^ ]+a(,|:)" | cut -d ":" -f1 | cut -c3,4 | sort -n | uniq -c | head -n 1 | tr -s ' ')
