extends CanvasLayer

@onready var animation: AnimationPlayer = $animation

var die:bool=false
func start():
	animation.play("start")
	SoundManager.SFX(Preloads.sounds["fadeout"],-10)
	var tween := create_tween()
	tween.tween_property(SoundManager,"EnvironmentVolume",0,0.2).set_ease(Tween.EASE_IN).set_delay(0.3)


func die_trans(Die:bool=true):
	animation.play("DieTrans")
	die = Die
	SoundManager.SFX(Preloads.sounds["fadein"],-10)
	var tween := create_tween()
	tween.tween_property(SoundManager,"EnvironmentVolume",-8,0.2).set_ease(Tween.EASE_IN)


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "DieTrans" and die:
		get_tree().reload_current_scene()
