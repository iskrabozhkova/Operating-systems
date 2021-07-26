#!/bin/bash

find . -type f -printf "%p %n\n" | sort -nr -t ' ' -k2 | head -n 5 | awk '{print $1}' 