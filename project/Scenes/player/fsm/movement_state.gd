extends State
class_name PlayerMovment

@export var acc: = 2000.0
@export var dec: = 1400.0

func Enter():
	print("movment inter")


func process_physics(delta:float):
	var movement = Input.get_axis("ui_left","ui_right")
	
	if movement == 0 and is_zero_approx(parent.velocity.x):
		state_transition.emit(self,"idle")
	
	var target_speed = movement * move_speed
	var accel = acc if abs(target_speed) > abs(parent.velocity.x) else dec
	parent.velocity.x = move_toward(parent.velocity.x, target_speed, accel * delta)
	parent.move_and_slide()

func Exit():
	print("movment exit")
