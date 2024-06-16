#/bin/bash

TARGET_FILE=$(pwd)/file9.txt

if test -f "$TARGET_FILE"
then
	echo "`cat $TARGET_FILE`"
else
	trap
		echo "Error: Command failed with exit status $?" >&2
		exit 2
fi
