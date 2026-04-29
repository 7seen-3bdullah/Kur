extends Area2D

var player_coll:bool=false
var stop_body:bool=false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if stop_body:
			Global.Player.die()
			return
		
		player_coll = true
		stop_body = true
		animation_player.play("new_animation")
		$Timer.start()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_coll = false


func _on_timer_timeout() -> void:
	SoundManager.SFX(Preloads.sounds["spike"],-15,randf_range(0.9,1.1))
	if player_coll:
		Global.Player.die()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
