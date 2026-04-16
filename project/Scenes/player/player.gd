extends CharacterBody2D
class_name player

@export var line_2d: Line2D
@export var Icon:AnimatedSprite2D

@onready var state_machine: FiniteStateMachine = $FSM
@onready var right_wall: RayCast2D = $raycast/right_wall
@onready var left_wall: RayCast2D = $raycast/left_wall
@onready var hook_raycast: RayCast2D = $raycast/hookRaycast

var nearest_wall:int=0
var slide_time:float=0.0
var run_time: float = 0.0
var updown:=0.0
var can_hook:bool=false
var is_hooking:bool=false
var hook_raycast_dir:Vector2
var hook_target_position:Vector2
var last_input_dir: Vector2i = Vector2i.ZERO
var coyote_time := 0.1
var hook_dir_coyote_timer := 0.0
var coyote_x_timer:=0.0
var coyote_hook_miss:=0.0
var hook_anchor:Vector2
var is_swining:bool=false
var tween:Tween
var tween_data:Dictionary={
	"before_touch_grownd":[Vector2(1.15,0.85),0.07,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_touch_grownd":[Vector2(1,1),0.14,Tween.EASE_OUT,Tween.TRANS_BACK],
	"before_jump":[Vector2(1.12,0.88),0.06,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_jump":[Vector2(0.88,1.12),0.10,Tween.EASE_OUT,Tween.TRANS_BACK],
	"fall":[Vector2(1.08,0.92),0.13,Tween.EASE_IN,Tween.TRANS_QUAD],
	"normal":[Vector2(1,1),0.12,Tween.EASE_OUT,Tween.TRANS_QUAD]
}

func _ready() -> void:
	Global.Player=self
	right_wall.add_exception(self)
	left_wall.add_exception(self)
	hook_raycast.add_exception(self)
	hook_target_position = hook_raycast.target_position


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
func _process(delta: float) -> void:
	state_machine.process(delta)
func _physics_process(delta: float) -> void:
	
	if velocity.x >0:
		Icon.flip_h=false
	elif velocity.x <0:
		Icon.flip_h=true
	
	if velocity != Vector2.ZERO and line_2d:
		line_2d.add_point(global_position)
	
	state_machine.process_physics(delta)
	Input_dir_update(delta)
	Hook(delta)
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


func Input_dir_update(delta):
	var x_axis := int(Input.get_axis("ui_left","ui_right"))
	var y_axis := int(Input.get_axis("ui_up","ui_down"))
	
	var input_dir := Vector2(x_axis, y_axis).normalized()
	if input_dir != Vector2.ZERO:
		last_input_dir = input_dir
		hook_dir_coyote_timer = coyote_time
	else:
		if hook_dir_coyote_timer > 0:
			hook_dir_coyote_timer -= delta
			input_dir = last_input_dir
		else:
			input_dir = Vector2.ZERO
	
	hook_raycast_dir = input_dir
	print("hook dir: ", hook_raycast_dir)

func Hook(delta):
	if Input.is_action_just_pressed("x"):
		coyote_x_timer = coyote_time
	
	if coyote_x_timer >0:
		coyote_x_timer -= delta
	if coyote_hook_miss > 0:
		coyote_hook_miss -= delta
	else:
		can_hook = false
	
	if hook_dir_coyote_timer <= 0:
		hook_raycast.enabled = false
	else:
		hook_raycast.enabled = true
	
	hook_raycast.target_position = hook_target_position
	hook_raycast.target_position *= hook_raycast_dir
	
	print("hook start coll: ", can_hook)
	
	if hook_raycast.is_colliding():
		var body = hook_raycast.get_collider()
		if body != null and body.is_in_group("Anchor_point"):
			hook_anchor = body.global_position
			can_hook = true
			coyote_hook_miss = coyote_time


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
	
	var wave = (sin(slide_time * 4.0) + 1.0) * 0.5
	
	var target_scale = Vector2(
		lerp(0.97, 0.92, wave),
		lerp(1.03, 1.08, wave)
	)
	
	Icon.scale = Icon.scale.lerp(target_scale, 6 * delta)

func run_squash(delta: float, max_speed: float):
	return
	var speed = abs(velocity.x)
	
	if speed < 0.05:
		Icon.scale = Icon.scale.lerp(Vector2.ONE, 8 * delta)
		run_time = 0.0
		return
	
	var speed_ratio = clamp(speed / max_speed, 0.0, 1.0)
	var frequency = lerp(2.5, 4.5, speed_ratio)
	
	run_time += delta * frequency
	
	var wave = (sin(run_time) + 1.0) * 0.5
	
	var target_scale = Vector2(
		lerp(1.01, 1.04, wave),
		lerp(0.99, 0.96, wave)
	)
	
	Icon.scale = Icon.scale.lerp(target_scale, 8 * delta)

func set_animation(Name:String=""):
	if name == "":
		push_error("non animation name selected!")
		return
	
	Icon.play(Name)
