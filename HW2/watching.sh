#/bin/bash

while inotifywait -r ~/watch -e create file;
	do
		if [["$file" ~= .*]]; then
		echo "`cat $file`"
		mv "$file" *.back
		fi
	done
