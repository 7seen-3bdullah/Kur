extends State

@export var slide_speed:float=7.5
@export var slide_timer:float=0.5

var timer_to_fall:float=0.0
var grav_timer = 0.0
var grav_delay = 0.1

func Enter():
	timer_to_fall = slide_timer
	is_transitioning=false
	
	print("states: wallslide enter")


func process(delta:float):
	var input = Input.get_axis("ui_left","ui_right")
	if input ==0:
		timer_to_fall -= 1 * delta
	else:
		timer_to_fall = slide_timer
	print(timer_to_fall)
	if timer_to_fall <=0:
		can_slide = false

func process_physics(delta:float):
	if parent.is_on_wall() and !is_zero_approx(timer_to_fall):
		parent.velocity.y = gravity *slide_speed * delta
	
	if (Input.is_action_just_pressed("ui_accept") and parent.is_on_wall()) or walljump_buffer_timer == true:
		parent.velocity.x = wall_jump_velocity/1.2 * parent.nearest_wall
		parent.velocity.y = wall_jump_velocity
		grav_timer = grav_delay
		walljump_buffer_timer=false
	
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
