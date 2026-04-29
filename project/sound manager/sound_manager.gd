extends Node

@export var Environment1:AudioStreamPlayer
@export var Environment2:AudioStreamPlayer

var EnvironmentVolume:float=0:
	set(value):
		var bus = AudioServer.get_bus_index("Enviromnment")
		set_bus_volume(bus,value)
var SFXVolume:float=0:
	set(value):
		var bus = AudioServer.get_bus_index("SFX")
		set_bus_volume(bus,value)


func fade_in_out(EnvIn:AudioStreamPlayer,EnvOut:AudioStreamPlayer,time:float=1,vol:float=-80):
	await fade_in(EnvIn,time,vol)
	fade_out(EnvOut,time,vol)
func fade_out(Env:AudioStreamPlayer,time:float=1,vol:float=-80):
	if not Env.playing:
		push_error("Environment audio is not playing!")
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(Env,"volume_db",vol,time)
	await tween.finished
	Env.stop()
func fade_in(Env:AudioStreamPlayer,time:float=1,vol:float=0):
	if not Env.playing:
		Env.play()
	Env.volume_db=0.0
	var tween:=create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(Env,"volume_db",vol,time)
	await tween.finished

func SFX(sound:AudioStreamOggVorbis,volume:float=0.0,pitch:float=1.0):
	var audio := AudioStreamPlayer.new()
	audio.stream=sound
	add_child(audio)
	add_sounde(audio,volume,pitch)
func SFX2D(sound:AudioStreamOggVorbis,position:Vector2,volume:float=0.0,pitch:float=1.0):
	var audio := AudioStreamPlayer2D.new()
	audio.stream=sound
	audio.global_position=position
	add_child(audio)
	add_sounde(audio,volume,pitch)
func add_sounde(audio,volume:float,pitch:float):
	audio.bus="SFX"
	audio.volume_db=volume
	audio.pitch_scale=pitch
	audio.play()
	audio.finished.connect(audio.queue_free)

func set_bus_volume(bus: int, volume: float):
	volume = clamp(volume, -80.0, 0.0)
	if bus != -1:
		AudioServer.set_bus_volume_db(bus, volume)
