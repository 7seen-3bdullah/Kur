extends Node
class_name State

@warning_ignore("unused_signal")
signal state_transition

var parent
var is_transitioning:bool = false

var move_speed :float = 110.0
var acc: = 800.0
var dec: = 1000.0

var jump_velocity:float = -210.0
var hook_jump_velocity:float = -200
var wall_jump_velocity:float = -130.0

var gravity:float = 700.0
var fall_multiplier:float = 1.3

var jump_cut:float = 0.6
var max_fall_speed:float = 420.0

var input_buffer_timer:float=0.0
var input_buffer_delay:float= .1
var coyote_timer:float=0.0
var jump_dir:int=1

static var can_slide:bool=true
static var walljump_buffer_timer:bool=false
static var coyote_jump:bool=false
static var stuck_in_idle:bool=false

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
