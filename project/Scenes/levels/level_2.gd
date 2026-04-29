extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.last_save_poin != Vector2.ZERO and Global.level == 1:
		Global.Player.global_position = Global.last_save_poin
