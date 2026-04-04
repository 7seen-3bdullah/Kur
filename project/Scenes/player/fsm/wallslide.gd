extends State

@export var slide_speed:float=7.5
@export var slide_timer:float=0.5

var timer_to_fall:float=0.0
var tween_slide_delay:=0.1
var grav_timer = 0.0
var grav_delay = 0.1
var jump_locked := false
var tween_slide:bool=false

func Enter():
	print("states: wallslide enter")
	
	timer_to_fall = slide_timer
	tween_slide_delay = 0.1
	is_transitioning=false
	tween_slide=false
	jump_locked = Input.is_action_pressed("ui_accept")

func process(delta:float):
	var input = Input.get_axis("ui_left","ui_right")
	if input ==0:
		timer_to_fall -= 1 * delta
	else:
		timer_to_fall = slide_timer
	print(timer_to_fall)
	if timer_to_fall <=0:
		can_slide = false
	
	if tween_slide_delay >0:
		tween_slide_delay -= delta
	else:
		tween_slide = true
	

func process_physics(delta:float):
	if parent.is_on_wall() and !is_zero_approx(timer_to_fall):
		parent.velocity.y = gravity *slide_speed * delta
		if tween_slide:
			parent.wall_slide(delta)
	
	if Input.is_action_just_released("ui_accept"):
		jump_locked=false
	
	if Input.is_action_just_pressed("ui_accept") and parent.is_on_wall() or (walljump_buffer_timer and !jump_locked):
		parent.velocity.x = wall_jump_velocity/1.2 * parent.nearest_wall
		parent.velocity.y = wall_jump_velocity
		grav_timer = grav_delay
		walljump_buffer_timer=false
		
		parent.state_tween("before_jump","after_jump")
	
	
	if grav_timer > 0:
		grav_timer -= delta
	else:
		_gravity(delta)
	_transition()
	parent.move_and_slide()

func _gravity(delta: float):
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
		if !parent.is_on_wall() and parent.velocity.y >0 and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"fall")
		
		var input_axis = Input.get_axis("ui_left","ui_right")
		if parent.is_on_wall() and input_axis != parent.nearest_wall and input_axis != 0 and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"fall")

func Exit():
	print("states: wallslide exit")
