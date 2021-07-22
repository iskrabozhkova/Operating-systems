#!/bin/bash

read -p "Enter 3 file names: " first second third
cat $first $second | sort > $third
