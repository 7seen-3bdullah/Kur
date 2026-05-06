extends Control

const CLICK_1 = preload("uid://denbhbdeg5uyk")
const CLICK_2 = preload("uid://buxt7gt4owhf")
const SLIDEUI = preload("uid://dwnw8a8filf8d")


@onready var setting: Control = $setting
@onready var startbu: Button = $start
@onready var settingbutton: Button = $settingbutton
@onready var quitbut: Button = $quit
@onready var backebut: Button = $setting/backe
@onready var dialoganim: AnimationPlayer = $CanvasLayer/dialog/AnimationPlayer

var setting_main_pos:=Vector2(-1440,-816)
var setting_start_pos:=Vector2(-1000,-816)
var starting:=false

func _ready() -> void:
	Transitions.start()


func setting_show(open:bool):
	var tween := create_tween().set_parallel(true)
	if open:
		setting.show()
		backebut.show()
		backebut.scale = Vector2.ONE
		setting.position = setting_start_pos
		setting.modulate = Color(1.0, 1.0, 1.0, 0.0)
		tween.tween_property(setting,"modulate",Color.WHITE,0.3).set_ease(Tween.EASE_OUT)
		tween.tween_property(setting,"position",setting_main_pos,0.3).set_ease(Tween.EASE_OUT)
		startbu.hide_tween(0.15)
		settingbutton.hide_tween(0.15)
		quitbut.hide_tween(0.15)
		
	else:
		settingbutton.show_tween(0.2)
		startbu.show_tween(0.2)
		quitbut.show_tween(0.2)
		tween.tween_property(setting,"modulate",Color(1.0, 1.0, 1.0, 0.0),0.4).set_ease(Tween.EASE_OUT)
		tween.tween_property(setting,"position",setting_start_pos,0.4).set_ease(Tween.EASE_OUT)
		await tween.finished
		setting.hide()



func _on_settingbutton_pressed() -> void:
	if starting:
		return
	await settingbutton.press_tween(0.1)
	setting_show(true)


func _on_backe_pressed() -> void:
	
	#await backebut.press_tween(0.1)
	setting_show(false)


func _on_master_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	SoundManager.set_bus_volume(bus,value)
	SoundManager.SFX(SLIDEUI,-5,randf_range(0.8,1.2))


func _on_music_value_changed(value: float) -> void:
	SoundManager.EnvironmentVolume = value
	SoundManager.SFX(SLIDEUI,-5,randf_range(0.8,1.2))


func _on_sfx_value_changed(value: float) -> void:
	SoundManager.SFXVolume = value
	SoundManager.SFX(SLIDEUI,-5,randf_range(0.8,1.2))


func _on_quit_pressed() -> void:
	if starting:
		return
	await quitbut.press_tween(0.1)
	Transitions.die_trans(false)
	await get_tree().create_timer(0.6).timeout
	get_tree().quit()


func _on_start_pressed() -> void:
	if starting:
		return
	await startbu.press_tween(0.1)
	Transitions.die_trans(false)
	await get_tree().create_timer(0.6).timeout
	dialoganim.play("dialog")
	starting = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dialog":
		get_tree().change_scene_to_file("res://Scenes/levels/level_1.tscn")
