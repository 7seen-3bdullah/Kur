extends Node2D

func _physics_process(delta: float) -> void:
	print("fps: ", Engine.get_frames_per_second())
