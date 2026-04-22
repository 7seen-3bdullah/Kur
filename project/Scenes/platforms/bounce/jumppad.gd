extends Area2D

@export var jumpVelocity:float=300.0

@onready var sprite_2d: Sprite2D = $Sprite2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween := create_tween()
		
		tween.tween_property(sprite_2d,"scale",Vector2(1.2,0.8),0.08)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite_2d,"scale",Vector2(0.8,1.2),0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite_2d,"scale",Vector2(1,1),0.1)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		
		body.velocity.y = -jumpVelocity
