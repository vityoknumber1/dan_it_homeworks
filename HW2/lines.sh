#/bin/bash

read -p "Enter a filename: " $(pwd)/$1

echo "Number of lines in $1 `wc -l < $1`"
