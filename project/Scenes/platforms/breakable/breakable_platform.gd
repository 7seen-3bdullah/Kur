extends StaticBody2D

@export var breakTime:float=0.5
@export var untile_player_out:bool=false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player_enter

func _ready() -> void:
	$Icon.material = $Icon.material.duplicate()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("shake")
		SoundManager.SFX(Preloads.sounds["shake2"],-10,randf_range(0.9,1.1))
		player_enter = true
		
		if untile_player_out:
			return
		
		await get_tree().create_timer(breakTime).timeout
		
		#add sound
		var break_node = Preloads.BREAKING_SHADER.instantiate()
		break_node.global_position = position
		get_parent().add_child(break_node)
		queue_free()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if player_enter and untile_player_out:
			#add sound
			var break_node = Preloads.BREAKING_SHADER.instantiate()
			break_node.global_position = position
			get_parent().add_child(break_node)
			queue_free()
