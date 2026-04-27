extends Node

const plaer_rope = preload("uid://djs21ibcyel0f")
const player_texture = preload("uid://bqhue6juny50s")
const BREAKING_SHADER = preload("uid://bkem7dfitjfev")
const RUNPARTICALS = preload("uid://b4v1vf3b4eau")


var sounds:Dictionary={
	"Environment":{
		
	}
}


func add_scene(scene_to_load: PackedScene, parent: Node, pos: Vector2):
	if scene_to_load == null:
		push_error("Scene Not found: ", scene_file_path)
		return
	
	var node_ref = scene_to_load.instantiate()
	
	if node_ref is Node2D or node_ref is Control:
		#if isn't ui
		node_ref.global_position = pos
	
	parent.add_child(node_ref)
