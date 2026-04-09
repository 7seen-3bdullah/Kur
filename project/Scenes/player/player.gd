extends CharacterBody2D
class_name player

@export var line_2d: Line2D
@export var Icon:AnimatedSprite2D

@onready var state_machine: FiniteStateMachine = $FSM
@onready var right_wall: RayCast2D = $raycast/right_wall
@onready var left_wall: RayCast2D = $raycast/left_wall

var nearest_wall:int=0
var slide_time:float=0.0
var run_time: float = 0.0
var updown:=0.0
var is_swining:bool=false
var tween:Tween
var tween_data:Dictionary={
	"before_touch_grownd":[Vector2(1.2,0.7),0.06,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_touch_grownd":[Vector2(1,1),0.1,Tween.EASE_OUT,Tween.TRANS_QUAD],
	"before_jump":[Vector2(1.2,0.85),0.08,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_jump":[Vector2(0.85,1.2),0.1,Tween.EASE_OUT,Tween.TRANS_QUINT],
	"fall":[Vector2(1.1,0.85),0.15,Tween.EASE_IN_OUT,Tween.TRANS_QUAD],
	"normal":[Vector2(1,1),0.1,Tween.EASE_OUT,Tween.TRANS_QUAD]
}

func _ready() -> void:
	Global.Player=self
	right_wall.add_exception(self)
	left_wall.add_exception(self)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
func _process(delta: float) -> void:
	state_machine.process(delta)
func _physics_process(delta: float) -> void:
	
	if velocity != Vector2.ZERO and line_2d:
		line_2d.add_point(global_position)
	
	state_machine.process_physics(delta)
	Ray_wall_collide()
	if is_on_floor():
		run_squash(delta, Global.GlobalState.move_speed)


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

func wall_slide(delta: float):
	slide_time += delta
	var wave = (sin(slide_time * 8.0) + 1.0) * 0.5
	
	var target_scale = Vector2(
		lerp(0.95, 0.85, wave),
		lerp(1.05, 1.15, wave)
	)
	Icon.scale = target_scale
	print("update slide time: ", Icon.scale)
	
	#joy vibration

func run_squash(delta: float, max_speed: float):
	var speed = abs(velocity.x)
	
	if speed < 0.05:
		Icon.scale = Icon.scale.lerp(Vector2.ONE, 10 * delta)
		run_time = 0.0
		return
	
	var speed_ratio = clamp(speed / max_speed, 0.0, 1.0)
	var frequency = lerp(3.5, 6.5, speed_ratio)
	
	run_time += delta * frequency
	
	var wave = (sin(run_time) + 1.0) * 0.5
	var target_scale = Vector2(
		lerp(1.02, 1.05, wave),
		lerp(0.98, 0.95, wave)
	)
	
	Icon.scale = Icon.scale.lerp(target_scale, 10 * delta)
	print("update move scale: ", Icon.scale)

func set_animation(Name:String=""):
	if name == "":
		push_error("non animation name selected!")
		return
	
	Icon.play(Name)
