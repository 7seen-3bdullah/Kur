extends State


func Enter():
	is_transitioning=false
	print("states: movment enter")

func process_physics(delta:float):
	var movement = Input.get_axis("ui_left","ui_right")
	var target_speed = movement * move_speed
	var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
	parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	
	
	_transtiion(movement)
	parent.move_and_slide()

func _transtiion(dir):
	if Input.is_action_just_pressed("ui_accept") and !is_transitioning:
		is_transitioning = true
		state_transition.emit(self,"jump")
	if dir == 0 and is_zero_approx(parent.velocity.x):
		if parent.is_on_floor()and !is_transitioning:
			is_transitioning = true
			state_transition.emit(self,"idle")
	if !parent.is_on_floor()and !is_transitioning:
		is_transitioning=true
		state_transition.emit(self,"fall")

func Exit():
	print("states: movment exit")
