extends Camera2D

@export_category("shake")
@export var decay: float = 8.0
@export var enable_x: bool = true
@export var enable_y: bool = true

var strength: float = 0.0
var shake_time: float = 0.0
var overlapping_zones: Array = []
var active_zone: Area2D
var player_node: CharacterBody2D
var follow_player:bool = false

func _ready() -> void:
	add_to_group("RoomZoneCamera2D")
	player_node = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if shake_time > 0.0:
		shake_time -= delta
		var x = randf_range(-1, 1) * strength if enable_x else 0.0
		var y = randf_range(-1, 1) * strength if enable_y else 0.0
		offset = Vector2(x, y).round()
		strength = lerp(strength, 0.0, decay * delta)
	else:
		offset = Vector2.ZERO
		strength = 0.0
	
	if !player_node:
		player_node = get_tree().get_first_node_in_group("player")
		return
	
	if overlapping_zones.is_empty() or (overlapping_zones.size() == 1 and active_zone == overlapping_zones[0]):
		return
	
	var new_zone = get_closest_zone()
	if new_zone != active_zone:
		active_zone = new_zone
		apply_zone_settings()


func _physics_process(_delta: float) -> void:
	if follow_player and player_node:
		global_position = player_node.global_position

 

func apply_shake(amount: float, duration: float):
	strength = max(amount, strength)
	shake_time = max(duration, shake_time)


func get_closest_zone() -> Area2D:
	var closest_zone:Area2D = null
	var closest_dist: float = INF
	var player_pos:Vector2 = player_node.global_position
	
	for zone in overlapping_zones:
		var zone_shape: CollisionShape2D = zone.collisionshape
		var col_margin:float = 0.1
		var zone_shape_pos: Vector2 = zone_shape.global_position
		var zone_shape_extents:Vector2 = zone_shape.shape.extents
		var shape_sides: Array[Vector2] = [
			Vector2(zone_shape_pos.x - zone_shape_extents.x + col_margin, player_pos.y),
			Vector2(zone_shape_pos.x + zone_shape_extents.x - col_margin, player_pos.y),
			Vector2(player_pos.x, zone_shape_pos.y - zone_shape_extents.y + col_margin),
			Vector2(player_pos.x, zone_shape_pos.y + zone_shape_extents.y - col_margin)
		]
		var closest_dist_shapeside := INF
		for col_side in shape_sides:
			var col_dist: float = player_pos.distance_to(col_side)
			if col_dist < closest_dist_shapeside:
				closest_dist_shapeside = col_dist
		
		if closest_dist_shapeside < closest_dist:
			closest_dist = closest_dist_shapeside
			closest_zone = zone
	
	return closest_zone

func apply_zone_settings():
	zoom = active_zone.zoom
	
	follow_player = active_zone.follow_player
	if !active_zone.follow_player:
		global_position = active_zone.fixed_position
	
	if active_zone.limit_camera:
		limit_enabled = true
		limit_left = active_zone.left
		limit_top = active_zone.top
		limit_right = active_zone.right
		limit_bottom = active_zone.bottom
	else:
		limit_enabled = false
