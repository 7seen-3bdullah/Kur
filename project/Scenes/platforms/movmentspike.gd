extends Area2D

@export var time:float = 0.2
@export var distance := 32
@export_enum("left","right","up","down") var dir := "left"
@export var breakable:bool=false

var start_move:=false

func _ready() -> void:
	if breakable:
		$Sprite2D.region_rect = Rect2(112,48,16,16)

func move():
	if start_move:
		var move_to:Vector2
		if dir == "left":
			move_to = Vector2(distance * -1 +position.x,position.y)
		elif dir == "right":
			move_to = Vector2(distance+position.x, position.y)
		elif dir == "up":
			move_to = Vector2(position.x,distance * -1 + position.y)
		else:
			move_to = Vector2(position.x, distance + position.y)
		
		var tween := create_tween()
		tween.tween_property(self,"global_position",move_to,time)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if start_move:
			return
		
		start_move = true
		move()


func _on_killzone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()


func _on_breakzone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
