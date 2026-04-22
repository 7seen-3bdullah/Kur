extends Area2D
@export var delay:float=0.2
@onready var spik: Sprite2D = $spik



var body_enter:bool=false
var Body
var rect1 = Rect2(32,97,31,31)
var rect2 = Rect2(64,97,31,31)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body_enter = true
		Body = body
		
		await get_tree().create_timer(delay).timeout
		spik.region_rect = rect1
		var tween := create_tween()
		tween.tween_property(spik,"scale",Vector2(1.1,0.9),0.08)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(spik,"scale",Vector2(1,1),0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		await tween.finished
		if body_enter and Body != null:
			Body.die()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body_enter = false
		Body = null
		
		await get_tree().create_timer(0.5).timeout
		spik.region_rect = rect2
		var tween := create_tween()
		tween.tween_property(spik,"scale",Vector2(0.9,1.1),0.08)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(spik,"scale",Vector2(1,1),0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	
