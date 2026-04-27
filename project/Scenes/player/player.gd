extends CharacterBody2D
class_name player

@export var line_2d: Line2D
@export var Icon:AnimatedSprite2D

@onready var state_machine: FiniteStateMachine = $FSM
@onready var right_wall: RayCast2D = $raycast/right_wall
@onready var left_wall: RayCast2D = $raycast/left_wall
#@onready var hook_raycast: RayCast2D = $raycast/hookRaycast
@onready var Hook_raycasts: Node2D = $raycast/hook_raycast
@onready var hook_rope: Line2D = $Line2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var slidepart: GPUParticles2D = $slidepart
@onready var slidepart_2: GPUParticles2D = $slidepart2
@onready var run_marker_2d: Marker2D = $runMarker2D
@onready var dashghost: Timer = $dashghost
@onready var wave_hook: AnimationPlayer = $wave_hook



var nearest_wall:int=0
var slide_time:float=0.0
var run_time: float = 0.0
var player_in_wall:bool = false
var updown:=0.0
var can_hook:bool=false
var is_hooking:bool=false
var is_dead:bool=false
var partrunplaying:bool = false
var hook_raycast_dir:Vector2
var hook_target_position:Vector2
var last_input_dir: Vector2i = Vector2i.ZERO
var coyote_time := 0.1
var hook_dir_coyote_timer := 0.0
var coyote_x_timer:=0.0
var coyote_hook_miss:=0.0
var hook_anchor:Vector2
var is_swining:bool=false
var finsh_flip_fice_tween:bool=false
var start_timer:=true
var hook_body
var tween:Tween
var tween_data:Dictionary={
	"before_touch_grownd":[Vector2(1.15,0.85),0.1,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_touch_grownd":[Vector2(1,1),0.14,Tween.EASE_OUT,Tween.TRANS_BACK],
	"before_jump":[Vector2(1.12,0.88),0.06,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"after_jump":[Vector2(0.88,1.12),0.10,Tween.EASE_OUT,Tween.TRANS_BACK],
	"fall":[Vector2(1.08,0.92),0.13,Tween.EASE_IN,Tween.TRANS_QUAD],
	"breathing":[Vector2(1.02,1.01),0.1,Tween.EASE_IN_OUT,Tween.TRANS_SINE],
	"idle":[Vector2(1.08,0.93),0.1,Tween.EASE_OUT,Tween.TRANS_SINE],
	"hook":[Vector2(1.2,0.8),0.08,Tween.EASE_OUT,Tween.TRANS_CUBIC],
	"normal":[Vector2(1,1),0.12,Tween.EASE_OUT,Tween.TRANS_QUAD],
}

func _ready() -> void:
	Global.Player=self
	right_wall.add_exception(self)
	left_wall.add_exception(self)
	
	for child in Hook_raycasts.get_children():
		(child as RayCast2D).add_exception(self)
	
	await (get_tree().create_timer(1).timeout)
	start_timer = false


func _unhandled_input(event: InputEvent) -> void:
	if start_timer:
		return
	
	state_machine.process_input(event)
func _process(delta: float) -> void:
	if start_timer:
		return
	
	state_machine.process(delta)


 
func _physics_process(delta: float) -> void:
	if start_timer:
		return
	
	if !player_in_wall:
		if velocity.x >0:
			Icon.flip_h=false
		elif velocity.x <0:
			Icon.flip_h=true
	else:
		Icon.flip_h=false
	
	if velocity != Vector2.ZERO and line_2d:
		line_2d.add_point(global_position)
	
	state_machine.process_physics(delta)
	Input_dir_update(delta)
	Hook(delta)
	Ray_wall_collide()
	hook_raycast_colliding()
	hook_line()
	tilemap_collision()
	if is_on_floor():
		run_squash(delta, Global.GlobalState.move_speed)

func tilemap_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is spike_tilemaps:
			die()
			return

func Ray_wall_collide():
	if is_on_floor():
		return
	if right_wall.is_colliding() and !left_wall.is_colliding():
		var collision = right_wall.get_collider()
		if collision is spike_tilemaps:
			nearest_wall = 0
			return
		else:nearest_wall = 1
	elif !right_wall.is_colliding() and left_wall.is_colliding():
		var collision = left_wall.get_collider()
		if collision is spike_tilemaps:
			nearest_wall = 0
			return
		else:
			nearest_wall = -1
	else:
		nearest_wall = 0
	print("nearest wall is: ", nearest_wall)


func Input_dir_update(delta):
	var x_axis := int(Input.get_axis("ui_left","ui_right"))
	var y_axis := int(Input.get_axis("ui_up","ui_down"))
	
	var input_dir := Vector2(x_axis, y_axis)
	if input_dir != Vector2.ZERO:
		last_input_dir = input_dir
		hook_dir_coyote_timer = coyote_time
	else:
		if hook_dir_coyote_timer > 0:
			hook_dir_coyote_timer -= delta
			input_dir = last_input_dir
		else:
			if Icon.flip_h:
				input_dir = Vector2(-1,0)
			else:input_dir = Vector2(1,0)
	
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
	
	
	if hook_raycast_dir == Vector2(1,0):
		Hook_raycasts.rotation_degrees = 0
	elif hook_raycast_dir == Vector2(0,-1):
		Hook_raycasts.rotation_degrees = -90
	elif hook_raycast_dir == Vector2(-1,0):
		Hook_raycasts.rotation_degrees = 180
	elif hook_raycast_dir == Vector2(0,1):
		Hook_raycasts.rotation_degrees = 90
	if hook_raycast_dir == Vector2(1,-1):
		Hook_raycasts.rotation_degrees = -45
	elif hook_raycast_dir == Vector2(1,1):
		Hook_raycasts.rotation_degrees = 45
	elif hook_raycast_dir == Vector2(-1,-1):
		Hook_raycasts.rotation_degrees = -135
	elif hook_raycast_dir == Vector2(-1,1):
		Hook_raycasts.rotation_degrees = 135
	
	print("hook start coll: ", can_hook)

func hook_raycast_colliding():
	for child in Hook_raycasts.get_children():
		if (child as RayCast2D).is_colliding():
			var body = child.get_collider()
			if body != null and body.is_in_group("Anchor_point"):
				hook_anchor = body.global_position
				hook_body = body
				can_hook = true
				coyote_hook_miss = coyote_time
	
	#if hook_raycast.is_colliding():
		#var body = hook_raycast.get_collider()
		#if body != null and body.is_in_group("Anchor_point"):
			#hook_anchor = body.global_position
			#can_hook = true
			#coyote_hook_miss = coyote_time

func hook_line():
	if Icon.animation == "hook":
		if Icon.frame == 1:
			if Icon.flip_h:
				hook_rope.position.x = -10
			else:
				hook_rope.position.x = 10
			
			var local_anchor = hook_rope.to_local(hook_anchor)
			var local_origin = hook_rope.to_local(global_position)
			hook_rope.points = [
				local_origin,
				local_anchor
			]
			hook_body.hook_enter(hook_raycast_dir.normalized())
			await get_tree().create_timer(0.08).timeout
			hook_rope.clear_points()
			state_tween("after_jump")


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
	var speed = abs(velocity.x)
	
	if speed < 0.05:
		Icon.scale = Icon.scale.lerp(Vector2.ONE, 8 * delta)
		run_time = 0.0
		
		if Icon.animation == "idle":
			if Icon.frame == 0 or Icon.frame == 9:
				var idle_tween
				var normal_tween
				if tween_data.has("idle"):
					idle_tween = tween_data["idle"]
				else:return
				if tween_data.has("normal"):
					normal_tween = tween_data["normal"]
				else:return
				
				if tween:
					tween.kill()
				
				tween = create_tween()
				finsh_flip_fice_tween = false
				
				tween.tween_property(Icon,"scale",idle_tween[0],idle_tween[1])\
				.set_ease(idle_tween[2]).set_trans(idle_tween[3])
				
				tween.tween_property(Icon,"scale",normal_tween[0],0.1)\
				.set_ease(normal_tween[2]).set_trans(normal_tween[3])
				
				await tween.finished
				finsh_flip_fice_tween = true
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

func slide_particals(start:bool):
	if start == false:
		slidepart.hide()
		slidepart_2.hide()
		return
	if nearest_wall == 1:
		slidepart.position.x = 5
		slidepart_2.position.x = 5
		slidepart.scale.x = -1
		slidepart_2.scale.x = -1
	else:
		slidepart.position.x = -5
		slidepart_2.position.x = -5
		slidepart.scale.x = 1
		slidepart_2.scale.x = 1
	slidepart.show()
	slidepart_2.show()


func set_animation(Name:String=""):
	if name == "":
		push_error("non animation name selected!")
		return
	
	Icon.play(Name)

func die():
	if is_dead:
		return
	
	is_dead = true
	await Global.frame_freeze(0.0,0.2)
	_reload_scene()

func _reload_scene():
	get_tree().reload_current_scene()


func _on_icon_frame_changed() -> void:
	if Icon.animation == "run":
		if Icon.frame == 3 or Icon.frame == 7:
			var eff = Preloads.RUNPARTICALS.instantiate()
			eff.global_position = run_marker_2d.global_position
			if Icon.flip_h:
				eff.scale.x = -1
			get_parent().add_child(eff)

func ghost_timer(start:bool):
	if start:
		dashghost.start()
		add_ghost()
	else:
		dashghost.stop()

func _on_dashghost_timeout() -> void:
	add_ghost()

func add_ghost():
	var ghost = Preloads.GHOST.instantiate()
	ghost.scale = Icon.scale
	ghost.flip_h = Icon.flip_h
	ghost.global_position = Icon.global_position
	get_parent().add_child(ghost)
	print("add ghost effect")
