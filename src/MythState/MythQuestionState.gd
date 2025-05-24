extends "res://src/MythState/MythState.gd"

signal question_presented

@export var messagebox: TimedLabel
@export var edit_box: TextEdit

@export_range(0,1, 0.05) var answer_threshold: float

var _myth: Myth
var _myth_segments: Array[MythSegment]
var current_segment: MythSegment


func _generate_question_set(_myth: Myth) -> Array[MythSegment]:
	var array: Array[MythSegment] = _myth.myth_base.duplicate()
	array.shuffle()
	array.resize(randi_range(1, array.size()/2))
	return array


func enter(myth: Myth):
	if myth:
		_myth = myth
		_myth_segments = _generate_question_set(_myth)
		current_segment = _myth_segments.front()
		messagebox.set_new_text(myth.get_question_introduction())
	
	state_entered.emit()


func advance():
	current_segment = _myth_segments.pop_front()
	
	if !current_segment:
		Scenemanager.return_to_main()
		return
	
	messagebox.set_new_text(current_segment.question)
	question_presented.emit()


func exit():
	state_exited.emit()



##
## ANSWER FUNCTIONS


func _on_user_answer_recieved(answer: String):
	var thread = NltkInterface.new_similarity_thread(answer, current_segment.text)
	edit_box.process_mode = Node.PROCESS_MODE_DISABLED
	##TODO: Implement animation call
	messagebox.set_new_text("Hmmm...")
	print(thread)
	NltkInterface.similarity_check_completed.connect(_on_similarity_check_completed.bind(answer), Node.CONNECT_ONE_SHOT)



func _on_similarity_check_completed(value: float, answer: String):
	edit_box.process_mode = Node.PROCESS_MODE_INHERIT
	
	if value >= answer_threshold:
		## logic for success response
		current_segment.text = answer
		MythLoader.save_myth(_myth)
		##TODO: Implement animation call
		messagebox.set_new_text(_myth.positive_reaction)
		await get_tree().create_timer(2.0).timeout
		state_machine.advance()
		return
	
	##Logic for failed response
	##TODO: Implement animation call
	messagebox.set_new_text(_myth.negative_reaction)
	await get_tree().create_timer(2.0).timeout
	state_machine.advance()
	return

