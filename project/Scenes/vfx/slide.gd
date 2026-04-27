extends AnimatedSprite2D


func _ready() -> void:
	play("wall_slide")


func _on_animation_finished() -> void:
	queue_free()
