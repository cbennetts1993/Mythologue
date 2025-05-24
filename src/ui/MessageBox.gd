class_name TimedLabel
extends Label


@export_range(0,1, 0.01) var interval: float = 0.2

var time_elapsed: float = 0

func _ready():
	visible_characters = 0


func set_new_text(new_text):
	if text != new_text:
		text = new_text
		visible_characters = 0


func _process(delta):
	time_elapsed += delta
	if time_elapsed >= interval:
		timer_tick()
		time_elapsed = 0


func timer_tick():
	visible_characters += 1


