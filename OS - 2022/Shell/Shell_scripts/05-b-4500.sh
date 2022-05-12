#!/bin/bash

read -p "Enter username: " username

who | grep -q "$username"
echo $?