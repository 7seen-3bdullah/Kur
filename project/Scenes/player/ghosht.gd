extends Sprite2D


func _ready() -> void:
	var tween :=create_tween()
	tween.tween_property(self,"modulate",Color(1.0, 1.0, 1.0, 0.0),0.4).set_ease(Tween.EASE_OUT)
	await tween.finished
	queue_free()
