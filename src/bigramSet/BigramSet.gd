class_name BigramSet
extends RefCounted


##Initialize from a string
func _init(from_string: String):
	bigrams = _get_string_bigrams(from_string)


var string: String:
	get = get_string

func get_string() -> String:
	var r_string: String = ""
	
	for element in bigrams.size():
		var bigram = bigrams[element]
		r_string += bigram.word1 + " "
		
		if element == bigrams.size() - 1:
			r_string += bigram.word2
		
	return r_string


var bigrams: Array[Bigram] = []

func has(bigram: Bigram) -> bool:
	for element in bigrams:
		if element.is_equal_to(bigram):
			return true
	return false


## Generates a bigram set from a sentence string
func _get_string_bigrams(from_string: String) -> Array[Bigram]:
	var word_bigrams: Array[Bigram] = []
	var previous_string: String
	
	for word in from_string.split(" ", false):
		if previous_string:
			word_bigrams.append(Bigram.new(previous_string, word))
		previous_string = word
	
	return word_bigrams


## Returns a value 0 to 1 on how closely the bigram sets match
## This is known as the dice-sorenson coefficient
func compare_bigram_set(other_bigram_set: BigramSet) -> float:
	var dice_sorenson_index: float = 0
	
	var common_elements: Array[Bigram] = []
	
	for bigram in bigrams:
		if other_bigram_set.has(bigram):
			common_elements.append(bigram)
	
	var set_size: float = bigrams.size() + other_bigram_set.bigrams.size()
	
	dice_sorenson_index = 2 * common_elements.size() / set_size
	
	return dice_sorenson_index
