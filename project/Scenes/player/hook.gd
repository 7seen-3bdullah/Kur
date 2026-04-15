extends State

var speed:float=400.0

func Enter():
	print("states: hook enter")

func process_physics(delta:float):
	var direction = parent.hook_anchor - parent.global_position
	var distance = direction.length()
	var stop_distance = 16.0
	if distance > stop_distance:
		parent.velocity = direction.normalized() * speed
	else:
		parent.velocity = parent.hook_raycast_dir.normalized() * -jump_velocity
		state_transition.emit(self, "fall")
	
	parent.move_and_slide()

func Exit():
	print("states: hook exit")
