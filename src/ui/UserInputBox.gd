extends TextEdit

signal answer_submitted

func submit_answer():
	var answer = text
	clear()
	answer_submitted.emit(answer)


func _input(event):
	if event.is_action_released("enter_key"):
		submit_answer()


func enable():
	self.process_mode = Node.PROCESS_MODE_INHERIT

func disable():
	self.process_mode = Node.PROCESS_MODE_DISABLED
