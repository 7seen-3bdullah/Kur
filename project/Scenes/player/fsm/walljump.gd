extends State

func Enter():
	super()
	pass

func process_physics(delta:float):
	parent.velocity = Vector2(jump_velocity ,jump_velocity * parent.nearest_wall)
	
	_gravity(delta)
	parent.move_and_slide()

func _gravity(delta: float):
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta * fall_multiplier


#func 
