class_name WordSet
extends RefCounted


##Initialize from a string
func _init(from_string: String):
	words = _get_string_word_set(from_string)


var string: String:
	get = get_string

func get_string() -> String:
	var r_string: String = ""
	
	for element in words.size():
		r_string += words[element] + " "
		
	return r_string


var words: Array[String] = []

func has(word: String) -> bool:
	return words.has(word)


## Generates a bigram set from a sentence string
func _get_string_word_set(from_string: String) -> Array[String]:
	var word_set: Array[String] = []
	
	for word in from_string.split(" ", false):
		word_set.append(word)
	
	return word_set


## Returns a value 0 to 1 on how closely the bigram sets match
## This is known as the dice-sorenson coefficient
func compare_bigram_set(other_word_set: WordSet) -> float:
	var dice_sorenson_index: float = 0
	
	var common_elements: Array[String] = []
	
	for word in words:
		if other_word_set.has(word):
			common_elements.append(word)
	
	var set_size: float = words.size() + other_word_set.words.size()
	
	dice_sorenson_index = 2 * common_elements.size() / set_size
	
	return dice_sorenson_index
