extends State

func Enter():
	print("states: idle enter")
	parent.velocity = Vector2.ZERO


func process_input(event: InputEvent):
	if Input.get_axis("ui_left","ui_right"):
		state_transition.emit(self, "movement")
	
	if event.is_action_pressed("ui_accept"):
		state_transition.emit(self,"jump")

func Exit():
	print("states: idle exit")
