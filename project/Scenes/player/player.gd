extends CharacterBody2D
class_name player

@export var line_2d: Line2D
@export var Icon:Sprite2D

@onready var state_machine: FiniteStateMachine = $FSM
@onready var right_wall: RayCast2D = $raycast/right_wall
@onready var left_wall: RayCast2D = $raycast/left_wall

var nearest_wall:int=0
var updown:=0.0
var tween:Tween
var tween_data:Dictionary={
	"before_touch_grownd":[Vector2(1.2,0.7),0.06,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_touch_grownd":[Vector2(1,1),0.1,Tween.EASE_OUT,Tween.TRANS_QUAD],
	"before_jump":[Vector2(1.2,0.85),0.08,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_jump":[Vector2(0.85,1.2),0.1,Tween.EASE_OUT,Tween.TRANS_QUINT],
	"fall":[Vector2(1,1),0.1,Tween.EASE_IN_OUT,Tween.TRANS_QUAD],
}

func _ready() -> void:
	right_wall.add_exception(self)
	left_wall.add_exception(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
func _process(delta: float) -> void:
	state_machine.process(delta)
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	Ray_wall_collide()
	if Input.is_action_just_pressed("ui_accept"):
		updown+=0.1
		print("vibration is: ", updown)
	Input.start_joy_vibration(0,updown,updown,0)
	if velocity != Vector2.ZERO and line_2d:
		line_2d.add_point(global_position)


func Ray_wall_collide():
	if is_on_floor():
		return
	if right_wall.is_colliding() and !left_wall.is_colliding():
		nearest_wall = 1
	elif !right_wall.is_colliding() and left_wall.is_colliding():
		nearest_wall = -1
	else:
		nearest_wall = 0
	print("nearest wall is: ", nearest_wall)


func state_tween(state:String, second_state:String=""):
	if Icon == null:
		return
	
	if !tween_data.has(state):
		push_error("Missing tween state: " + state)
		return
	
	if tween:
		tween.kill()
	
	var data:Array = tween_data[state]
	
	var has_second := second_state != "" and tween_data.has(second_state)
	var second_data:Array
	
	if has_second:
		second_data = tween_data[second_state]
	
	tween = create_tween()
	
	tween.tween_property(Icon, "scale", data[0], data[1])\
		.set_ease(data[2])\
		.set_trans(data[3])
	
	if has_second:
		tween.tween_property(Icon, "scale", second_data[0], second_data[1])\
			.set_ease(second_data[2])\
			.set_trans(second_data[3])
