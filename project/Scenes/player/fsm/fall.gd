extends State


func Enter():
	print("states: fall enter")
	is_transitioning=false
	walljump_buffer_timer=false
	coyote_timer = input_buffer_delay
	parent.is_swining=false
	
	parent.state_tween("fall")


func process_physics(delta:float):
	var movement = Input.get_axis("ui_left","ui_right")
	
	if parent.velocity.y >0:
		var target_speed = movement * move_speed
		var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
		parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	
	
	if Input.is_action_just_pressed("ui_accept"):
		input_buffer_timer=input_buffer_delay
	
	_gravity(delta)
	_transition(movement)
	if input_buffer_timer >0:
		input_buffer_timer -= delta
	if coyote_timer >0:
		coyote_timer -= delta
	else:
		coyote_jump=false
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
	if parent.is_on_floor() and is_zero_approx(parent.velocity.y):
		if input_buffer_timer >0:
			state_transition.emit(self,"jump")
			parent.velocity.y = jump_velocity
			is_transitioning=true
			return
		
		if dir == 0:
			if !is_transitioning:
				is_transitioning=true
				state_transition.emit(self,"idle")
		else:
			if !is_transitioning:
				is_transitioning=true
				state_transition.emit(self,"movement")
		
		parent.state_tween("before_touch_grownd","after_touch_grownd")
	else:
		if Input.is_action_just_pressed("ui_accept") and coyote_timer>0 and !is_transitioning:
			state_transition.emit(self,"jump")
			
			is_transitioning=true
			return
		
		if parent.is_on_wall() and parent.velocity.y >0 and can_slide and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"wallslide")
			if input_buffer_timer >0:
				walljump_buffer_timer=true
				print("buffer jump: ", walljump_buffer_timer)
			
			parent.state_tween("normal")

func Exit():
	print("states: fall exit")
