extends State

func Enter():
	print("states: idle enter")
	is_transitioning=false
	walljump_buffer_timer=false
	parent.is_swining=false
	parent.velocity = Vector2.ZERO


func process_physics(delta:float):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if !is_transitioning:
			is_transitioning=true
			state_transition.emit(self, "movement")
	
	if Input.is_action_just_pressed("ui_accept") and parent.is_on_floor():
		if !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"jump")
	
	if !parent.is_on_floor():
		state_transition.emit(self,"fall")
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
	print("states: idle exit")
	can_slide=true
