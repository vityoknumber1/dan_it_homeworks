class Alphabet:
	def __init__(self, lang, letters):
        	self.lang = lang
        	self.letters = letters

	def print(self, alphabet):
		print(" ".join(self.alphabet))

	def letters_num(self, alphabet):
		return len(self.alphabet)


class EngAlphabetClass(Alphabet):
	alphabet = list("abcdefghijklmnopqrstuvwxyz")
    
	def __init__(self, eng, alphabet):
		self.eng = eng
		self.alphabet = alphabet
		super().__init__(eng, alphabet)
	
	_letters_num = 26

	def is_en_letter(self, letter):
		if str(letter).lower() in self.alphabet:
			print(f"{letter} is in alphabet:")
		else:
			print("This letter is not in alphabet:")

	def letters_num(self, alphabet):
		print("Number of letters of the alphabet: ", EngAlphabetClass._letters_num)

	@staticmethod
	def example():
		print("This is example of english lang")



if __name__ == "__main__":

	eng_alph = EngAlphabetClass("English", "abcdefghijklmnopqrstuvwxyz")
	eng_alph.print(Alphabet)
	eng_alph.letters_num(Alphabet)
	print("Is 'F' in English alphabet?")
	eng_alph.print(eng_alph.is_en_letter('F'))
	print("Is 'Щ' in English alphabet")
	eng_alph.print(eng_alph.is_en_letter('Щ'))
	eng_alph.example()
	
