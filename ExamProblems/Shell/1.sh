#!/bin/bash

echo "Number of searched lines is: $(cat philip-j-fry.txt | grep -e "[02468]" | grep -v [a-w] | wc -l)"