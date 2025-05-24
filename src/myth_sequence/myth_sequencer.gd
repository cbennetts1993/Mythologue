extends Node

signal myth_state_entered
signal myth_state_finished

signal question_state_entered
signal question_state_finished


## Takes in a Myth resource and runs the sequence of mythsegments and questions
@export var myth: Myth:
	set = set_myth

func set_myth(_new_myth: Myth):
	if myth != _new_myth:
		myth = _new_myth


var current_myth_segment_index: int = 0

func get_current_myth_segment() -> MythSegment:
	if current_myth_segment_index >= myth.myth_base.size(): return null
	return myth.myth_base[current_myth_segment_index] if myth else null



var current_question_index: int = 0

var question_set: Array[MythSegment]

func _generate_question_set(_myth: Myth) -> Array[MythSegment]:
	var array: Array[MythSegment] = _myth.myth_base.duplicate()
	array.shuffle()
	array.resize(randi_range(1, array.size()))
	return array

func get_current_question() -> MythSegment:
	if question_set.is_empty(): return null
	return question_set.front()

func next_question() -> MythSegment:
	question_set.pop_front()
	return get_current_question()



var state_method: Callable:
	set = _set_new_state_method

func _set_new_state_method(method):
	if state_method != method:
		state_method = method



func _on_next_element_requested():
	state_method.call()


func _ready():
	enter_myth_state()

##
## MYTH STATE FUNCTIONS

func enter_myth_state():
	state_method = advance_myth_state
	current_myth_segment_index = 0
	$MarginContainer/RichTextLabel.set_new_text(myth.get_introduction())
	myth_state_entered.emit()


func advance_myth_state():
	var next_segment: = get_current_myth_segment()
	
	if !next_segment:
		enter_question_state()
		return
	
	$MarginContainer/RichTextLabel.set_new_text(next_segment.text)
	current_myth_segment_index += 1


func exit_myth_state():
	myth_state_finished.emit()



##
## QUESTION STATE FUNCTIONS

func enter_question_state():
	question_set = _generate_question_set(myth)
	state_method = advance_question_state
	current_question_index = 0
	
	$MarginContainer/RichTextLabel.set_new_text(myth.get_question_introduction())
	question_state_entered.emit()


func advance_question_state():
	var next_segment: = get_current_question()
	
	if !next_segment:
		exit_question_state()
		return
	
	$MarginContainer/RichTextLabel.set_new_text(get_current_question().text)
	next_question()


func compare_answer(answer: String):
	NltkInterface.new_similarity_thread(answer, get_current_question().text)
	$MarginContainer2/TextEdit.process_mode = Node.PROCESS_MODE_DISABLED
	##TODO: Implement animation call
	NltkInterface.similarity_check_completed.connect(_on_similarity_check_completed.bind(answer), Node.CONNECT_ONE_SHOT)


func _on_similarity_check_completed(value: float, answer: String):
	$MarginContainer2/TextEdit.process_mode = Node.PROCESS_MODE_INHERIT
	var threshold: = 0.5
	
	if value >= threshold:
		## logic for success response
		var current_myth_segment = get_current_question()
		current_myth_segment.text = answer
		##TODO: Implement animation call
		advance_question_state()
		return
	
	##Logic for failed response
	##TODO: Implement animation call
	advance_question_state()
	return

func exit_question_state():
	question_state_finished.emit()
	Scenemanager.return_to_main()





