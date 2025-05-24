extends Node

signal initialize_myth_data

@export var main_scene: PackedScene

var current_scene: PackedScene
var previous_scene: PackedScene

func _ready():
	current_scene = load(get_tree().current_scene.scene_file_path)


func load_scene(scene: PackedScene, myth_data: Myth = null):
	## Start scene transition effects
	get_tree().paused = true
	
	var tween_in: = create_tween()
	tween_in.tween_property($CanvasLayer/ColorRect, "color", Color(Color.BLACK, 1), 0.3)
	
	await  tween_in.finished
	
	previous_scene = current_scene
	get_tree().change_scene_to_packed(scene)
	current_scene = scene
	
	
	
	var tween_out: = create_tween()
	tween_out.tween_property($CanvasLayer/ColorRect, "color", Color(Color.BLACK, 0), 0.6)
	
	get_tree().paused = false
	
	if myth_data:
		initialize_myth_data.emit(myth_data)


func return_to_previous_scene():
	if previous_scene:
		load_scene(previous_scene)


func return_to_main():
	if main_scene:
		load_scene(main_scene)

