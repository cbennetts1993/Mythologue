extends Button

@export var scene: PackedScene


func _ready():
	self.pressed.connect(_on_pressed)


func _on_pressed():
	if scene:
		Scenemanager.load_scene(scene)
