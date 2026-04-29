extends Area2D

var time_to_break:float=0.1
var start_time:bool=false

func _ready() -> void:
	$Sprite2D.material = $Sprite2D.material.duplicate()

func _process(delta: float) -> void:
	if start_time and time_to_break >0:
		time_to_break -=delta
	if time_to_break<=0:
		if start_time:
			start_time=false
			
			$Sprite2D/AnimationPlayer.play("break")
			SoundManager.SFX(Preloads.sounds["breakingvis"],-20,randf_range(0.9,1.1))

func _break():
	Global.frame_freeze(0.0,0.07)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_time=true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "break":
		queue_free()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_time = false
		time_to_break = 0.1
