extends Button

func _ready():
	self.pressed.connect(_return)


func _return():
	Scenemanager.return_to_previous_scene()
