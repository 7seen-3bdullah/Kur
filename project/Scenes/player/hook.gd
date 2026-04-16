extends State

var speed:float=400.0
var launch:bool = false
var hooked :bool= false
var dir:Vector2

func Enter():
	print("states: hook enter")
	
	parent.velocity = Vector2.ZERO
	dir = parent.hook_raycast_dir.normalized()
	launch = false
	hooked = false
	parent.is_hooking = true
	Global.frame_freeze(0.0,0.3)

func process_physics(delta:float):
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
	
	parent.move_and_slide()


func Exit():
	print("states: hook exit")
	
	parent.is_hooking = false
