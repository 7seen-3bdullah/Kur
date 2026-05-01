extends CanvasLayer

@onready var animation: AnimationPlayer = $animation

func start():
	animation.play("start")
	SoundManager.SFX(Preloads.sounds["fadeout"],-10)
	var tween := create_tween()
	tween.tween_property(SoundManager,"EnvironmentVolume",0,0.2).set_ease(Tween.EASE_IN).set_delay(0.3)


func die_trans():
	animation.play("DieTrans")
	SoundManager.SFX(Preloads.sounds["fadein"],-10)
	var tween := create_tween()
	tween.tween_property(SoundManager,"EnvironmentVolume",-8,0.2).set_ease(Tween.EASE_IN)


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "DieTrans":
		get_tree().reload_current_scene()
