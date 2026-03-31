extends Node
class_name State

@warning_ignore("unused_signal")
signal state_transition

var parent: player
var move_speed :float= 300.0
var acc: = 2000.0
var dec: = 1400.0
var jump_velocity:float = -400.0
var gravity:float = 1000.0
var fall_multiplier:float = 1.5
var jump_cut:float = 0.5
var max_fall_speed:float = 1200.0


func Enter():
	pass

func Exit():
	pass

func process_input(event: InputEvent):
	pass
func process(delta:float):
	pass
func process_physics(delta:float):
	pass
