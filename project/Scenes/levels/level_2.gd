extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.last_save_poin != Vector2.ZERO and Global.level == 1:
		Global.Player.global_position = Global.last_save_poin


func _on_next_level_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.level=3
		Global.last_save_poin = Vector2.ZERO
		Transitions.die_trans(false)
		await get_tree().create_timer(0.6).timeout
		get_tree().call_deferred("change_scene_to_file","res://Scenes/levels/level_3.tscn")
