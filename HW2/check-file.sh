#/bin/bash

TARGET_FILE="$(pwd)/file.txt"

if test -f "$TARGET_FILE"
then
	echo "$TARGET_FILE exists."
else
	echo "$TARGET_FILE doesn't exists."
fi
