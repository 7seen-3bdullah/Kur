extends Node2D
@onready var fallstatic: StaticBody2D = $map/fallstatic


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		%Area2D.set_deferred("monitoring",false)
		
		$map/fallstatic/fallstatic_animshake.play("fallstatic")
		await get_tree().create_timer(0.5).timeout
		$map/fallstatic/fallstatic_animshake.play("RESET")
		
		var tween := create_tween()
		tween.tween_property(fallstatic,"position",Vector2(528,48),0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		await tween.finished
		Global.camera_shake(6,3)


func _on_staticfallareakill_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
