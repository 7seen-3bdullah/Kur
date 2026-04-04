extends State

func Enter():
	print("states: idle enter")
	is_transitioning=false
	walljump_buffer_timer=false
	parent.velocity = Vector2.ZERO


func process_input(event: InputEvent):
	if Input.get_axis("ui_left","ui_right"):
		if !is_transitioning:
			is_transitioning=true
			state_transition.emit(self, "movement")
	
	if Input.is_action_just_pressed("ui_accept"):
		if !is_transitioning:
			is_transitioning=true
			state_transition.emit(self,"jump")

func process_physics(delta:float):
	if !parent.is_on_floor():
		state_transition.emit(self,"fall")

func Exit():
	print("states: idle exit")
	can_slide=true
