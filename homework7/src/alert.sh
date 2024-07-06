#!/bin/bash
#

ALERT=90 # alert % level

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read -r output;
do
	echo "$output"
	usep=$(echo "$output" | awk '{ print $1 }' | cut -d'%' -f1 )
	partition=$(echo "$output" | awk '{ print $2 }' )
	if [ $usep -ge $ALERT ]; then
		echo "Running out of space \"$partition ($usep%)\" on $hostname as on ($date)" >> /var/log/disk.log
	fi
done
