class_name MythSegment
extends Resource


@export_multiline var _base_text: String:
	set = set_base_text

func set_base_text(_new_base_text):
	if _new_base_text != _base_text:
		_base_text = _new_base_text


@export var text: String:
	set = set_text,
	get = get_text

func set_text(_new_text):
	if text != _new_text:
		text = _new_text
		#print("segment text set to: ", text)
		word_set = _generate_word_sets(text)
		divergence_history[divergence_history.size()] = get_divergence()


func get_text() -> String:
	return text


## Holds a set of word-bigrams that construct the myth and allow for comparison of divergence
var word_set: WordSet:
	set = _set_words

func _set_words(new_word_set):
	if word_set != new_word_set:
		word_set = new_word_set


## Generates a BigramSet from an initial string
func _generate_word_sets(from_string: String) -> WordSet:
	return WordSet.new(from_string)


## measure of how different the myth segment is from its baseline
var divergence: float:
	get = get_divergence

func get_divergence() -> float:
	return 1 - word_set.compare_bigram_set(WordSet.new(_base_text))


## history of divergence changes over time
@export var divergence_history: Dictionary


## Array to hold questions that are presented to the player. Be careful to make sentence appropriate
## To the myth in question. These questions do not change over time, so avoid using proper names etc.
@export var question: String = "NO QUESTION SET!"

func has_question() -> bool:
	return question != "NO QUESTION SET!"

