extends CharacterBody2D
class_name player

@export var line_2d: Line2D

@onready var state_machine: FiniteStateMachine = $FSM
@onready var right_wall: RayCast2D = $raycast/right_wall
@onready var left_wall: RayCast2D = $raycast/left_wall

var nearest_wall:int=0

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
	
	if velocity != Vector2.ZERO:
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
