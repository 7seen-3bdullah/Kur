extends State

func Enter():
	print("states: jump enter")


func process_physics(delta:float):
	var movement = Input.get_axis("ui_left","ui_right")
	if Input.is_action_just_pressed("ui_accept"):
		if parent.is_on_floor():
			parent.velocity.y = jump_velocity
		else:
			#TO DO: more power jumb meby?
			if parent.is_on_wall():
				parent.velocity.y = jump_velocity
				#jumb direction
	
	if Input.is_action_just_released("ui_accept") and parent.velocity.y < 0:
		parent.velocity.y *= jump_cut
	
	if parent.velocity.y >0:
		state_transition.emit(self,"fall")
	
	var target_speed = movement * move_speed
	var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
	parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	
	_gravity(delta)
	parent.move_and_slide()

func _gravity(delta: float):
	if !parent.is_on_floor():
		if parent.velocity.y > 0:
			parent.velocity.y += gravity * delta * fall_multiplier
		else:
			parent.velocity.y += gravity * delta
	if parent.velocity.y > max_fall_speed:
		parent.velocity.y = max_fall_speed

func Exit():
	print("states: jump exit")
