#!/bin/bash

if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]; then
    echo "Digits and letters only"
else
    echo "Not only digits and letters"
fi

exit 0