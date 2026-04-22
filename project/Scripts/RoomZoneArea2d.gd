extends Area2D
class_name RoomZoneArea2D

@export var zoom:Vector2 = Vector2.ONE
@export var follow_player:bool = false
@export var fixed_position:Vector2 = Vector2.ZERO
@export_category("limite")
@export var limit_camera:bool = false
@export var left:float=-10000
@export var top:float=-10000
@export var right:float= 10000
@export var bottom:float= 10000

var collisionshape: CollisionShape2D
var cam_node : Camera2D

func _ready() -> void:
	collisionshape = get_child(0)
	monitorable = false
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !cam_node:
			cam_node = get_tree().get_first_node_in_group("RoomZoneCamera2D")
		cam_node.overlapping_zones.append(self)
		
		Global.Player.start_timer = true
		await (get_tree().create_timer(0.3).timeout)
		Global.Player.start_timer = false

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !cam_node:
			cam_node = get_tree().get_first_node_in_group("RoomZoneCamera2D")
		cam_node.overlapping_zones.erase(self)
