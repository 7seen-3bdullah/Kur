extends Node2D
@onready var fallstatic: StaticBody2D = $map/fallstatic
@onready var framelabel: Label = $Label
@onready var sbox: Sprite2D = $sbox
@onready var kebord: Sprite2D = $kebord


var use_hook = false

func _ready() -> void:
	if Global.last_save_poin != Vector2.ZERO and Global.level == 0:
		Global.Player.global_position = Global.last_save_poin
	

func _process(delta: float) -> void:
	framelabel.text = str(Engine.get_frames_per_second())
	
	
	if use_hook:
		if Input.is_action_pressed("x"):
			Engine.time_scale = 1.0
			sbox.hide()
			kebord.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		%Area2D.set_deferred("monitoring",false)
		
		$map/fallstatic/fallstatic_animshake.play("fallstatic")
		await get_tree().create_timer(0.5).timeout
		$map/fallstatic/fallstatic_animshake.play("RESET")
		
		var tween := create_tween()
		tween.tween_property(fallstatic,"position",Vector2(528,48),0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		await tween.finished
		Global.camera_shake(6,3)
		SoundManager.SFX(Preloads.sounds["impact"],0,0.9)



func _on_staticfallareakill_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()


func _on_time_slow_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !use_hook:
		use_hook = true
		match Global.current_device:
			Global.InputDevice.KEYBOARD:
				print("using keyboard UI")
				kebord.show()
			Global.InputDevice.GAMEPAD:
				print("using gamepad UI")
				sbox.show()
		
		Global.slowe_time(0.35)


func _on_time_slow_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		Engine.time_scale = 1.0


func _on_next_level_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.level=1
		Global.last_save_poin = Vector2.ZERO
		Transitions.die_trans(false)
		await get_tree().create_timer(0.6).timeout
		get_tree().call_deferred("change_scene_to_file","res://Scenes/levels/level_2.tscn")
