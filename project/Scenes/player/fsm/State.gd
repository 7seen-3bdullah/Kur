extends Node
class_name State

@warning_ignore("unused_signal")
signal state_transition

var is_transitioning = false
var parent: player
var move_speed :float= 180.0
var acc: = 1200.0
var dec: = 1500.0
var jump_velocity:float = -320.0
var wall_jump_velocity:float = -250.0
var gravity:float = 900.0
var fall_multiplier:float = 1.5
var jump_cut:float = 0.5
var max_fall_speed:float = 500.0
var input_buffer_timer:float=0.0
var input_buffer_delay:float= .1
var coyote_timer:float=0.0
var jump_dir:int=1:
	set(value):
		if value != 1 or value != -1:
			push_error("the Jump Direction value is: ", value)

static var can_slide:bool=true
static var walljump_buffer_timer:bool=false
static var coyote_jump:bool=false

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
