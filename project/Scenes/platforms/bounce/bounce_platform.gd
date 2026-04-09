extends StaticBody2D

@onready var up: Area2D = $up
@onready var left: Area2D = $left
@onready var right: Area2D = $right


@export_enum("up","left","right") var Bounce_direction = "up"
@export var target_position:Vector2
@export var delay:float=0.5
@export var time:float=.5
@export var time_to_backe:float=3

var first_position

func _ready() -> void:
	if Bounce_direction == "up":
		up.monitoring = true
	elif Bounce_direction == "left":
		left.monitoring = true
	else:
		right.monitoring = true
	
	
	first_position = global_position

func Bounce():
	await get_tree().create_timer(delay).timeout
	var tween:=create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position",target_position,time)
	tween.tween_property(self,"position",first_position,time_to_backe).set_delay(delay+delay)


func _on_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.GlobalState.stuck_in_idle = true


func _on_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.GlobalState.stuck_in_idle = true


func _on_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.GlobalState.stuck_in_idle = true
