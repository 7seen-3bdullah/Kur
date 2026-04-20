extends Area2D

var velocity_y := 0.0
var Gravity := 1200.0

var body_enter:bool=false
var stop_fall:bool=false

@onready var target_raycast: RayCast2D = $RayCast2D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$normal.material = $normal.material.duplicate()
	$normal2.material = $normal2.material.duplicate()

func _physics_process(delta: float) -> void:
	if target_raycast:
		if target_raycast.is_colliding():
			var body = target_raycast.get_collider()
			if body.is_in_group("player"):
				body.die()
			
			target_raycast.enabled = false
			stop_fall = true
			animation.play("break")
			if Global.camera != null:
				Global.camera.apply_shake(1,3)
	
	
	if body_enter and !stop_fall:
		velocity_y += Gravity * delta
		position.y += velocity_y * delta



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !body_enter:
		animation.play("shake")
		await get_tree().create_timer(0.3).timeout
		animation.play("RESET")
		target_raycast.enabled = true
		body_enter = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "break":
		queue_free()
