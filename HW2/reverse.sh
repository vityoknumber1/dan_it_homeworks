#/bin/bash

read -p "Enter the sentence: " str

echo $(tac -s ' ' <<< $str)
