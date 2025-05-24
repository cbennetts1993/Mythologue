class_name MythStateMachine
extends Node

@export var myth: Myth:
	set = set_myth

func set_myth(_new_myth: Myth):
	if myth != _new_myth:
		myth = _new_myth

@export_group("States")
@export var story_state: MythState
@export var question_state: MythState


@export var initial_state: MythState:
	set(_default):
		initial_state = _default
		_state = initial_state

var _state: MythState

func _init():
	Scenemanager.initialize_myth_data.connect(initialize_state_machine)

func _ready():
	for child in get_children():
		if child is MythState:
			child.state_machine = self


func initialize_state_machine(new_myth: Myth):
	print("myth data recieved")
	if new_myth:
		myth = new_myth
		_state.enter(myth)

func advance():
	_state.advance()


func change_state(new_state: MythState):
	if _state != new_state:
		_state.exit()
		_state = new_state
		_state.enter(myth)

