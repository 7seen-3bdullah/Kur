extends State

var speed:float=400.0
var launch:bool = false
var hooked :bool= false
var dir:Vector2

var staick_time:float=0.0

func Enter():
	print("states: hook enter")
	
	parent.velocity = Vector2.ZERO
	dir = parent.hook_raycast_dir.normalized()
	launch = false
	hooked = false
	parent.is_hooking = true
	staick_time = 0.5
	
	parent.set_animation("hook")
	parent.state_tween("hook")
	await get_tree().create_timer(0.08).timeout
	launch = true

@warning_ignore("unused_parameter")
func process_physics(delta:float):
	if !launch:
		return
	
	var direction = parent.hook_anchor - parent.global_position
	var distance = direction.length()
	var stop_distance = 16.0
	if !hooked:
		if distance > stop_distance:
			parent.velocity = direction.normalized() * speed
		else:
			hooked = true
			var velo = dir * -hook_jump_velocity
			parent.velocity = velo
			state_transition.emit(self,"fall")
	
	if staick_time >0:
		staick_time -= delta
		print("staic time: ", staick_time)
	else:
		if !is_transitioning:
			is_transitioning = true
			state_transition.emit(self,"fall")
	
	parent.move_and_slide()


func Exit():
	print("states: hook exit")
	
	parent.is_hooking = false
