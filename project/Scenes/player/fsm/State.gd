extends Node
class_name State

@warning_ignore("unused_signal")
signal state_transition

var parent: player
var move_speed :float= 300.0

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
