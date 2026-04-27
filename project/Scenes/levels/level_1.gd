extends Node2D
@onready var fallstatic: StaticBody2D = $map/fallstatic
@onready var framelabel: Label = $Label


var use_hook = false

func _ready() -> void:
	if Global.last_save_poin != Vector2.ZERO:
		Global.Player.global_position = Global.last_save_poin

func _process(delta: float) -> void:
	framelabel.text = str(Engine.get_frames_per_second())
	
	
	if use_hook:
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("x"):
			Engine.time_scale = 1.0

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


func _on_staticfallareakill_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()


func _on_time_slow_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !use_hook:
		use_hook = true
		Global.slowe_time(0.35)


func _on_time_slow_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		Engine.time_scale = 1.0
