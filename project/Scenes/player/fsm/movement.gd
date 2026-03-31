extends State


func Enter():
	print("states: movment enter")

func process_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		state_transition.emit(self,"jump")

func process_physics(delta:float):
	var movement = Input.get_axis("ui_left","ui_right")
	
	if movement == 0 and is_zero_approx(parent.velocity.x):
		if parent.is_on_floor():
			state_transition.emit(self,"idle")
	if !parent.is_on_floor():
			state_transition.emit(self,"fall")
	
	var target_speed = movement * move_speed
	var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
	parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	
	parent.move_and_slide()


func Exit():
	print("states: movment exit")
