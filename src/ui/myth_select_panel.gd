extends Control

@export var myth_sequence_scene: PackedScene
 
@export var myth_title_label: Label
@export var myth_generation_count_label: Label
@export var myth_divergence_label: Label


@export var current_myth: Myth:
	set = set_myth

func set_myth(_myth):
	if current_myth != _myth:
		current_myth = _myth


func _ready():
	if current_myth:
		myth_divergence_label.text = str((current_myth.divergence * 100)).pad_decimals(0) + "%"
		myth_generation_count_label.text = str(current_myth.generations)
		myth_title_label.text = current_myth.name


func _on_button_pressed():
	Scenemanager.load_scene(myth_sequence_scene, current_myth)
