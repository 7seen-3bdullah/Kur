extends Node

var GlobalState:=State.new()
var Player
var camera=null
var last_save_poin:Vector2=Vector2.ZERO

enum InputDevice {
	KEYBOARD,
	GAMEPAD
}
var current_device: InputDevice = InputDevice.KEYBOARD

func _ready() -> void:
	Engine.time_scale = 1.0

func _input(event):
	if event is InputEventKey:
		current_device = InputDevice.KEYBOARD
		print("input device: keboard")
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		current_device = InputDevice.GAMEPAD
		print("input device: gamepad")

func frame_freeze(timescale:float,duration:float) -> bool:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1.0
	return true

func slowe_time(time:float,delay:float=0.0,freeze:float=0.0):
	var tween := create_tween()
	tween.set_ignore_time_scale(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(Engine, "time_scale", freeze, time)
	if delay != 0:
		tween.tween_interval(delay)
		tween.tween_property(Engine, "time_scale", 1.0, time)

func camera_shake(amount: float, duration: float):
	if camera:
		camera.apply_shake(amount, duration)
