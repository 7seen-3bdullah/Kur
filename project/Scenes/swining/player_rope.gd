extends RigidBody2D

@export var Player:player

var prev_sign = 0
var center:Vector2
var time_kill:float=0.4
var x_vel:float=150.0
var y_vel:float=-350.0
var dir:int
var can_jump:bool=true

func _ready() -> void:
	if Global.Player.global_position.x > get_parent().global_position.x:
		dir = -1
	else:
		dir = 1
	x_vel *= dir

func _physics_process(delta: float) -> void:
	if center:
		check_reverse()
	
	if Input.is_action_just_released("x"):
		Global.Player.process_mode=ProcessMode.PROCESS_MODE_INHERIT
		get_parent().pin_joint_2d.node_b = NodePath("")
		get_parent().monitoring=true
		Global.Player.global_position = global_position
		Global.Player.show()
		if can_jump:
			if abs(rotation_degrees) >= 120:
				Global.Player.velocity.x = x_vel
				Global.Player.velocity.y = y_vel
			elif abs(rotation_degrees) < 120:
				if abs(rotation_degrees) >= 60:
					Global.Player.velocity.x = x_vel/1.5
					Global.Player.velocity.y = y_vel/2
		queue_free()

func check_reverse():
	var pos = global_position
	var r = pos - center
	var v = linear_velocity
	var cross = r.x * v.y - r.y * v.x
	var sign_dir = sign(cross)
	
	if prev_sign != 0 and sign_dir != 0:
		if sign_dir != prev_sign:
			gravity_scale = 0.1
			kill()
			return
	
	if sign_dir != 0:
		prev_sign = sign_dir

func kill():
	await get_tree().create_timer(0.15).timeout
	can_jump=false
	await get_tree().create_timer(time_kill).timeout
	get_parent().pin_joint_2d.node_b = NodePath("")
	get_parent().monitoring=true
	Global.Player.global_position = global_position
	Global.Player.show()
	Global.Player.process_mode=ProcessMode.PROCESS_MODE_INHERIT
	queue_free()
