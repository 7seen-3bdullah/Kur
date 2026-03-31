extends State

@export var slide_speed:float=6.5

func Enter():
	print("states: wallslide enter")

func process_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		state_transition.emit(self,"jump")

func process_physics(delta:float):
	if parent.is_on_wall():
		parent.velocity.y = gravity *slide_speed * delta
	
	if parent.is_on_floor():
		#TO DO: buffer input movememnt
		state_transition.emit(self,"idle")
	
	parent.move_and_slide()

func Exit():
	print("states: wallslide exit")
