extends State

func Enter():
	print("states: idle enter")
	parent.set_animation("idle")
	
	is_transitioning=false
	walljump_buffer_timer=false
	parent.is_swining=false
	parent.velocity = Vector2.ZERO


func process_physics(delta:float):
	if !stuck_in_idle:
		if parent.is_on_floor():
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				if !is_transitioning:
					is_transitioning=true
					state_transition.emit(self, "movement")
			
			if Input.is_action_just_pressed("ui_accept"):
				if !is_transitioning:
					is_transitioning=true
					parent.set_animation("jump")
					state_transition.emit(self,"jump")
		else:
			state_transition.emit(self,"fall")
	else:
		parent.velocity.x = 0
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
