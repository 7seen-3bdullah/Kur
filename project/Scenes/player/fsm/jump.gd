extends State


func Enter():
	print("states: jump enter")
	is_transitioning=false


func process_physics(delta:float):
	if Input.is_action_pressed("ui_accept"):
		if parent.is_on_floor():
			parent.velocity.y = jump_velocity
		else:
			#TO DO: more power jumb meby?
			if parent.is_on_wall():
				parent.velocity.y = jump_velocity
				parent.velocity.x = jump_velocity * parent.nearest_wall
	
	if Input.is_action_just_released("ui_accept") and parent.velocity.y < 0:
		parent.velocity.y *= jump_cut
	
	var movement = Input.get_axis("ui_left","ui_right")
	var target_speed = movement * move_speed
	var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
	parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	
	_gravity(delta)
	_transtiion()
	parent.move_and_slide()

func _gravity(delta: float):
	if !parent.is_on_floor():
		if parent.velocity.y > 0:
			parent.velocity.y += gravity * delta * fall_multiplier
		else:
			parent.velocity.y += gravity * delta
	if parent.velocity.y > max_fall_speed:
		parent.velocity.y = max_fall_speed

func _transtiion():
	if parent.velocity.y >0 and !is_transitioning:
		is_transitioning=true
		state_transition.emit(self,"fall")

func Exit():
	print("states: jump exit")
