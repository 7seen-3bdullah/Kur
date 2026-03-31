extends State

@export var slide_speed:float=6.5
@export var slide_timer:float=0.5

var timer_to_fall:float=0.0

func Enter():
	timer_to_fall = slide_timer
	is_transitioning=false   
	print("states: wallslide enter")


func process(delta:float):
	timer_to_fall -= 1 * delta
	print(timer_to_fall)
	if timer_to_fall <=0:
		can_slide = false

func process_physics(delta:float):
	if parent.is_on_wall() and !is_zero_approx(timer_to_fall):
		parent.velocity.y = gravity *slide_speed * delta
	print("the is_transition her is:", is_transitioning)
	
	
	_transition()
	parent.move_and_slide()

func _transition():
	if Input.is_action_just_pressed("ui_accept")and parent.is_on_wall() and !is_transitioning:
		is_transitioning=true
		state_transition.emit(self,"jump")
	if !can_slide and !is_transitioning:
		is_transitioning=true
		parent.velocity.x = -150 * parent.nearest_wall
		state_transition.emit(self,"fall")
	if parent.is_on_floor()and !is_transitioning:
		is_transitioning=true
		state_transition.emit(self,"idle")
	
	else:
		if !parent.is_on_wall() and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"fall")
		
		var input_axis = Input.get_axis("ui_left","ui_right")
		if input_axis != parent.nearest_wall and input_axis != 0 and !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"fall")

func Exit():
	print("states: wallslide exit")
