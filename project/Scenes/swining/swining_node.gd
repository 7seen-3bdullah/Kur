extends Node2D

var angle := 0.0
var radius := 0.0
@onready var circle: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	radius = circle.shape.radius

func _process(delta):
	angle += 2.0 * delta
	var x = global_position.x + cos(angle) * radius
	var y = global_position.y + sin(angle) * radius
	
	$Icon.global_position = Vector2(x, y)
