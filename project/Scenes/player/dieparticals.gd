extends GPUParticles2D


func _ready() -> void:
	emitting = true
	Global.camera_shake(7,0.1)
	SoundManager.SFX(Preloads.sounds["damage"],-10,randf_range(0.9,1.1))

func _on_finished() -> void:
	Transitions.die_trans()
