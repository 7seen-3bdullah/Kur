extends StaticBody2D

@export var breakTime:float=0.5
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$Icon.material = $Icon.material.duplicate()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("shake")
		await get_tree().create_timer(breakTime).timeout
		
		#add sound
		var break_node = Preloads.BREAKING_SHADER.instantiate()
		break_node.global_position = position
		get_parent().add_child(break_node)
		queue_free()
