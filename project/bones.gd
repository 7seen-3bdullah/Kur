extends Area2D
@onready var ggd: Sprite2D = $Ggd




func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ggd.region_rect = Rect2(0,8,16,8)
