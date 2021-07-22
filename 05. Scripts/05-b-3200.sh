#!/bin/bash

read -p "Enter directory: " dir

find "$dir" -type f | wc -l