extends State

@export var slide_speed:float=6.0
@export var slide_timer:float=100
@export var slide_delay:float=0.1

var time_for_sliding:float
var timer_to_fall:float=0.0
var tween_slide_delay:=0.1
var grav_timer = 0.0
var grav_delay = 0.1
var input_x_delay:float=0.2
var input_x:float=0
var start_sliding_timer:float
var jump_locked := false
var tween_slide:bool=false
var jump:bool = false

#problem: the player dos not do wall jump when stell press space. the problem meb

func Enter():
	print("states: wallslide enter")
	
	timer_to_fall = slide_timer
	input_x=input_x_delay
	time_for_sliding = slide_delay
	start_sliding_timer = slide_delay
	tween_slide_delay = 0.1
	is_transitioning=false
	tween_slide=false
	jump = false
	parent.player_in_wall = true
	#jump_locked = Input.is_action_pressed("ui_accept"c)x


func process(delta:float):
	var input = Input.get_axis("ui_left","ui_right")
	if input == 0:
		timer_to_fall -= delta
	else:
		timer_to_fall = slide_timer
	
	if timer_to_fall <=0 and start_sliding_timer <= 0:
		can_slide = false
	
	if tween_slide_delay >0 and start_sliding_timer <= 0:
		tween_slide_delay -= delta
	else:
		tween_slide = true
	
	if input_x > 0 and parent.is_on_wall():
		input_x -= delta
	
	if parent.is_on_wall():
		if parent.nearest_wall == 1:
			parent.set_animation("wall_slide_right")
		elif parent.nearest_wall == -1:
			parent.set_animation("wall_slide")
		else:
			parent.set_animation("jump")
	else:
		parent.set_animation("jump")
func process_physics(delta:float):
	if parent.is_on_wall() and !is_zero_approx(timer_to_fall) and !jump:
		if start_sliding_timer <= 0:
			parent.velocity.y = gravity * slide_speed * delta
			if tween_slide:
				parent.wall_slide(delta)
	
	if Input.is_action_just_released("ui_accept"):
		jump_locked=false
		jump = false
	
	if Input.is_action_just_pressed("ui_accept") and parent.is_on_wall() or (walljump_buffer_timer and !jump_locked):
		start_sliding_timer = 0
		parent.velocity.x = wall_jump_velocity * parent.nearest_wall
		parent.velocity.y = wall_jump_velocity
		grav_timer = grav_delay
		input_x=input_x_delay
		walljump_buffer_timer=false
		jump = true
		
		parent.state_tween("before_jump","after_jump")
	
	
	if grav_timer > 0:
		grav_timer -= delta
	else:
		_gravity(delta)
	_transition()
	parent.move_and_slide()

func _gravity(delta: float):
	if start_sliding_timer >0:
		start_sliding_timer -= delta
		return
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta * fall_multiplier

func _transition():
	
	if !can_slide and !is_transitioning:
		is_transitioning=true
		parent.velocity.x = -150 * parent.nearest_wall
		state_transition.emit(self,"fall")
	
	if parent.is_on_floor() and !is_transitioning:
		is_transitioning=true
		state_transition.emit(self,"idle")
		
		parent.state_tween("before_touch_grownd","after_touch_grownd")
	else:
		if parent.nearest_wall ==0 and parent.velocity.y > 0 and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"fall")
		
		var input_axis = Input.get_axis("ui_left","ui_right")
		if parent.nearest_wall ==0 and input_axis != parent.nearest_wall and input_axis != 0 and input_x <=0 and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"fall")

func Exit():
	print("states: wallslide exit")
	parent.player_in_wall = false
