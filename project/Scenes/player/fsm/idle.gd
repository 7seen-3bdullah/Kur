extends State

func Enter():
	print("states: idle enter")
	is_transitioning=false
	parent.velocity = Vector2.ZERO


func process_input(event: InputEvent):
	if Input.get_axis("ui_left","ui_right"):
		if !is_transitioning:
			is_transitioning=true
			state_transition.emit(self, "movement")
	
	if event.is_action_pressed("ui_accept"):
		if !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"jump")

func Exit():
	print("states: idle exit")
	can_slide=true
