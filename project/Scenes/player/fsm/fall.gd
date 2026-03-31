extends State

func Enter():
	is_transitioning=false
	print("states: fall enter")

func process_physics(delta:float):
	var movement = Input.get_axis("ui_left","ui_right")
	
	var target_speed = movement * move_speed
	var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
	parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	
	_gravity(delta)
	_transition(movement)
	parent.move_and_slide()

func _gravity(delta: float):
	if !parent.is_on_floor():
		if parent.velocity.y > 0:
			parent.velocity.y += gravity * delta * fall_multiplier
		else:
			parent.velocity.y += gravity * delta
	if parent.velocity.y > max_fall_speed:
		parent.velocity.y = max_fall_speed

func _transition(dir):
	if parent.is_on_floor():
		#TO DO: buffer jumb
		if dir == 0:
			if !is_transitioning:
				is_transitioning=true
				state_transition.emit(self,"idle")
		else:
			if !is_transitioning:
				is_transitioning=true
				state_transition.emit(self,"movement")
	else:
		if parent.is_on_wall() and can_slide and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"wallslide")

func Exit():
	print("states: fall exit")
