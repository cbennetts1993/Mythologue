extends Control


var select_button: PackedScene = preload("res://media/ui/myth_select_panel.tscn")


func _ready():
	for x in MythLoader.mythDB:
			create_myth_button(x)


func create_myth_button(myth: Myth):
	var new_button: = select_button.instantiate()
	if new_button.has_method("set_myth"):
		new_button.set_myth(myth)
	$MarginContainer/ScrollContainer/VBoxContainer.add_child(new_button)
