extends Button

@export_enum("StartGame","Setting","Credit","Exit") var stage = 0
@export var arrows:Sprite2D



func _on_focus_entered() -> void:
	if scale == Vector2.ONE:
		focus_tween(Vector2(1.2,1.2),0.1)
		var click = get_parent().CLICK_2
		SoundManager.SFX(click,-10)


func _on_focus_exited() -> void:
	if scale != Vector2.ONE:
		focus_tween(Vector2(1,1),0.2)


func _on_mouse_entered() -> void:
	if scale == Vector2.ONE:
		focus_tween(Vector2(1.2,1.2),0.1)
		var click = get_parent().CLICK_2
		SoundManager.SFX(click,-10)


func _on_mouse_exited() -> void:
	if scale != Vector2.ONE:
		focus_tween(Vector2(1,1),0.2,0.1)


func _on_pressed() -> void:
	var click = get_parent().CLICK_1
	SoundManager.SFX(click,-10)


func focus_tween(Scale:Vector2,dur:float,delay:float=0):
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self,"scale",Scale,dur).set_ease(Tween.EASE_OUT).set_delay(delay)
	

func hide_tween(dur:float):
	var tween := create_tween()
	tween.tween_property(self,"modulate",Color(1.0, 1.0, 1.0, 0.0),dur).set_ease(Tween.EASE_OUT)
	await tween.finished
	hide()

func show_tween(dur:float):
	show()
	scale = Vector2.ONE
	var tween := create_tween()
	tween.tween_property(self,"modulate",Color(1.0, 1.0, 1.0, 1.0),dur).set_ease(Tween.EASE_OUT)

func press_tween(dur:float) -> bool:
	var tween :=create_tween().set_parallel(true)
	
	tween.tween_property(self,"scale",Vector2(1.3,0.4),dur).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate",Color(1.0, 1.0, 1.0, 0.0),dur/1.1).set_ease(Tween.EASE_OUT)

	await tween.finished
	return true
