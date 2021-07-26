#!/bin/bash
#not tested

find "$(cat /etc/passwd | grep "/home/pesho" | cut -d " " -f6)" -type f -printf "%T@ %i %n\n" | sort -nr -t ' ' -k1 | awk '{if($3 > 1){print $2}}' | uniq | head -n 1