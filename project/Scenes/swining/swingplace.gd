extends Area2D

@onready var pin_joint_2d: PinJoint2D = $PinJoint2D
@onready var player_icon: Sprite2D = $playerIcon

@export var Radius :float= 50

var player_ref:player
var input_buffer:float=0
var buffer_delay:=0.1
var dir:int=1
var player_enter:bool=false
var buffer:bool=false

var playerrop

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("x"):
		input_buffer = buffer_delay
		buffer=true
	
	if buffer and player_enter:
		if !player_ref:
			push_error("no refrens for player")
			return
		buffer=false
		player_ref.process_mode=Node.PROCESS_MODE_DISABLED
		player_ref.is_swining=true
		player_ref.hide()
		if player_ref.position.x > position.x:
			dir = -1
		else:
			dir = 1
		
		_spawn_rope(player_ref)
	
	if input_buffer > 0:
		input_buffer -= delta
	else:
		buffer=false
	
	if player_icon.visible:
		if !playerrop:
			player_icon.hide()
			return
		player_icon.position = playerrop.position
		player_icon.look_at(position)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body
		player_enter=true

func _spawn_rope(body):
	monitoring = false
	
	var player_rope = Preloads.plaer_rope.instantiate()
	var ridus_rope:Vector2
	
	
	add_child(player_rope)
	ridus_rope = snap_to_circle(body.global_position,global_position,Radius)
	
	player_rope.global_position = ridus_rope
	player_rope.center = global_position
	player_icon.show()
	playerrop = player_rope
	player_icon.global_position = body.global_position
	pin_joint_2d.node_b = player_rope.get_path()
	player_enter = false
	print("player pos: ",body.global_position,"rope pos: ",player_rope.global_position)

func snap_to_circle(p: Vector2, center: Vector2, radius: float) -> Vector2:
	var Dir = p - center
	
	if Dir.length_squared() < 0.000001:
		Dir = Vector2.RIGHT
	else:
		Dir = Dir.normalized()
	
	return center + Dir * radius


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_enter=false
