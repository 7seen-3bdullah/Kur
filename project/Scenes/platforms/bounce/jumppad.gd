extends Area2D

@export var jumpVelocity:float=300.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween := create_tween()
		gpu_particles_2d.emitting = true
		gpu_particles_2d_2.emitting = true
		tween.tween_property(sprite_2d,"scale",Vector2(1.2,0.8),0.08)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite_2d,"scale",Vector2(0.8,1.2),0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite_2d,"scale",Vector2(1,1),0.1)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		SoundManager.SFX(Preloads.sounds["jumppad"],-5,randf_range(0.9,1.2))
		
		body.velocity.y = -jumpVelocity
		body.state_tween("before_jump","after_jump")
		body.set_animation("jump")
