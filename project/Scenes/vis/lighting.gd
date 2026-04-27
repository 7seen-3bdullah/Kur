extends Area2D

@export var stiffness := 30.0
@export var damping := 1.0
@onready var point_light_2d: PointLight2D = $PointLight2D

var start:bool = false
var angle := 0.0
var angular_velocity := 0.0


func _process(delta):
	
	if start:
		var force = -angle * stiffness
		angular_velocity += force * delta
		angular_velocity = lerp(angular_velocity, 0.0, damping * delta)
		
		angle += angular_velocity * delta
		
		rotation = angle
		if abs(angle) < 0.01 and abs(angular_velocity) < 0.01:
			start = false

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	$lightanim.play("new_animation")



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start = true
		var dir = sign(-body.velocity.x)
		angular_velocity += dir * 2.0
