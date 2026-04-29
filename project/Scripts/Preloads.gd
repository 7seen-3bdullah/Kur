extends Node

const plaer_rope = preload("uid://djs21ibcyel0f")
const player_texture = preload("uid://bqhue6juny50s")
const BREAKING_SHADER = preload("uid://bkem7dfitjfev")
const RUNPARTICALS = preload("uid://b4v1vf3b4eau")
const GHOST = preload("uid://c052ll7ci4bo6")

var last_sound_played:AudioStreamOggVorbis = null
var sounds:Dictionary={
	"Environment":{
		
	},
	"footsetp":[preload("uid://ddxrmb0eiuaqq"),
	preload("uid://da0qh2vh3nptp"),
	preload("uid://in0u8dx1emc6"), 
	preload("uid://caywuxk5ifbni"), 
	preload("uid://c34vo1amtd56e"), 
	preload("uid://dovqv5vg6ikla")
	],
	"hook": preload("uid://kbsd5ss5neoj"),
	"jump":preload("uid://xxhqaj7b83r1"),
	"landing":preload("uid://bpedvwkdnlqjo"),
	"jumppad":preload("uid://kp36yoga2d5h"),
	"rope":preload("uid://cgormpk5so4hv"),
	"rope2":preload("uid://cdcarmqwddtan"),
	"spike":preload("uid://bonuxyxuhmb3k"),
	"shake":preload("uid://bhthereq8kk1r"),
	"shake2":preload("uid://buotmdv853omr"),
	"breaking":preload("uid://do52c77wjeafd"),
	"breaking2":preload("uid://3us2acthljey"),
	"breakingvis":preload("uid://78se8au268kp"),
	"impact":preload("uid://ce55u0ely0xei")
}


func get_random_audio(key: String) -> AudioStreamOggVorbis:
	if !sounds.has(key):
		return null
	
	var audios: Array = sounds[key]
	if audios.is_empty():
		return null
	if audios.size() == 1:
		last_sound_played = audios[0]
		return audios[0]
	
	var audio: AudioStreamOggVorbis
	
	var attempts := 0
	while attempts < 10:
		audio = audios[randi() % audios.size()]
		if audio != last_sound_played:
			break
		attempts += 1
	
	last_sound_played = audio
	return audio

func add_scene(scene_to_load: PackedScene, parent: Node, pos: Vector2):
	if scene_to_load == null:
		push_error("Scene Not found: ", scene_file_path)
		return
	
	var node_ref = scene_to_load.instantiate()
	
	if node_ref is Node2D or node_ref is Control:
		#if isn't ui
		node_ref.global_position = pos
	
	parent.add_child(node_ref)
