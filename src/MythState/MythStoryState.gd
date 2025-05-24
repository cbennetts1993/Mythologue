extends "res://src/MythState/MythState.gd"

@export var messagebox: TimedLabel

var _myth: Myth
var _myth_segments: Array[MythSegment]
var current_segment: MythSegment


func enter(myth: Myth):
	if myth:
		_myth = myth
		_myth_segments = myth.myth_base.duplicate()
		current_segment = _myth_segments.front()
		messagebox.set_new_text(myth.get_introduction())
		
	state_entered.emit()


func advance():
	current_segment = _myth_segments.pop_front()
	
	if !current_segment:
		state_machine.change_state(state_machine.question_state)
		return
	
	messagebox.set_new_text(current_segment.text)


func exit():
	state_exited.emit()
