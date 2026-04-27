extends State

var jump_locked := false

func Enter():
	print("states: jump enter")
	
	is_transitioning=false
	walljump_buffer_timer=false
	jump_locked = Input.is_action_pressed("ui_accept")
	
	parent.state_tween("before_jump","after_jump")
	#parent.jump_particals()
	
	if parent.is_on_floor() or coyote_jump:
		parent.velocity.y = jump_velocity
		coyote_jump = false
	
	if Input.is_action_just_released("ui_accept") and parent.velocity.y < 0:
		parent.velocity.y *= jump_cut



func process_physics(delta:float):
	if parent.is_swining and !is_transitioning:
		state_transition.emit(self,"fall")
		is_transitioning=true
		return
	
	if Input.is_action_just_released("ui_accept") and parent.velocity.y < 0:
		parent.velocity.y *= jump_cut
	if Input.is_action_just_pressed("ui_accept") and !parent.is_on_floor():
		input_buffer_timer = input_buffer_delay
	
	
	var movement = Input.get_axis("ui_left","ui_right")
	var target_speed = movement * move_speed
	var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
	parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	
	if input_buffer_timer >0:
		input_buffer_timer -= delta
	
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
	if parent.hook_dir_coyote_timer > 0 and parent.coyote_x_timer >0 and parent.can_hook:
		if !is_transitioning:
			is_transitioning = true
			state_transition.emit(self,"hook")
	
	if parent.nearest_wall != 0 and !parent.is_on_floor() and !is_transitioning and parent.velocity.y >0:
		is_transitioning=true
		state_transition.emit(self,"wallslide")
		if input_buffer_timer >0:
			walljump_buffer_timer=true
			print("buffer jump: ", walljump_buffer_timer)
		
		parent.state_tween("fall","normal")
		return
	if parent.velocity.y >0 and !is_transitioning:
		is_transitioning=true
		state_transition.emit(self,"fall")


func Exit():
	print("states: jump exit")
	
	coyote_jump = false
