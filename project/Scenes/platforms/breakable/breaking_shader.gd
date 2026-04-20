extends Sprite2D

func _ready() -> void:
	$AnimationPlayer.play("new_animation")
	material = material.duplicate()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "new_animation":
		queue_free()
