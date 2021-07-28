#!/bin/bash
#not tested

inode=$(find ~ -type f -user velin -inum $(find . -type f -printf "%T %p %i\n" | sort -nr -t ' ' -k1 | head -n 1 | awk '{print $3}'))
find ~ -type f -user velin -inum $(inode) -printf "%p %d\n" | sort -n -t ' ' -k2 | head -n 1 | awk '{print $2}'
