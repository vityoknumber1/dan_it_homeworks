#/bin/bash
#

secret=$((1 + RANDOM % 100))

guess=0
echo "Guess a number between 1 and 100"

num=0

while [ "0$guess" -ne $secret ] ; do
	num=$((num+1))
	read guess
	[ "0$guess" -lt $secret ] && echo "Too low"
	[ "0$guess" -gt $secret ] && echo "Too high"
	
	if [ $num == 5 ]; then
		echo "Sorry, you have run out of attempts. The correct number was $secret"
		exit 0
	fi
done

echo "Congratulations! You guessed the right number"
exit 0
