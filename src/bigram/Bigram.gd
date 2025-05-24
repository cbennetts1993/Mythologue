class_name Bigram
extends RefCounted

var word1: String
var word2: String

var string: String:
	get:
		return str(word1 + word2)


func _init(_word1: String, _word2: String):
	word1 = _word1.to_lower()
	word2 = _word2.to_lower()


func has(word: String) -> bool:
	return word == word1 or word == word2


func is_equal_to(_bigram: Bigram) -> bool:
	return _bigram.word1 == word1 and _bigram.word2 == word2
