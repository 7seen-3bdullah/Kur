extends Node2D


@onready var dialog: Label = $"CanvasLayer/dialog"


func _on_next_level_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Transitions.die_trans(false)
		var tween := create_tween()
		tween.tween_property(dialog,"modulate",Color.WHITE,1).set_ease(Tween.EASE_IN).set_delay(1.5)
		tween.tween_property(dialog,"modulate",Color(0.0, 0.0, 0.0, 0.0),1).set_ease(Tween.EASE_IN).set_delay(3)
		await get_tree().create_timer(7.5).timeout
		get_tree().quit()
