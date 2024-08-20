import random

def random_function():
	value_rand = random.randint(1, 100)

	count = 0

	while True:
		count +=1
		value = int(input("Enter random number :"))
		if value == value_rand:
			print("Congratulations! You guessed the right number.")
			break

		elif value < value_rand:
			print("Too low")

		else:
			print("Too high")
		
		if count == 5:
			print(f"Sorry, you've run out of attempts. The correct number was {value_rand}")
			break

random_function()
