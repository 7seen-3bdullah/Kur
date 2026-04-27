extends Area2D

@onready var icon: Sprite2D = $icon
@onready var icon_2: Sprite2D = $icon/icon2

func hook_enter(pos:Vector2):
	var tween:=create_tween()
	tween.parallel()
	
	icon_2.show()
	remove_from_group("Anchor_point")
	
	tween.tween_property(icon,"scale",Vector2(0.9,1.1),0.08)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(icon,"position",pos * 4,0.08)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.chain()
	tween.tween_property(icon,"scale",Vector2(1.1,0.9),0.12)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(icon,"position",Vector2.ZERO,0.12)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	await tween.finished
	queue_free()
