extends CharacterBody2D
class_name player

@onready var state_machine: FiniteStateMachine = $FSM


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
func _process(delta: float) -> void:
	state_machine.process(delta)
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
