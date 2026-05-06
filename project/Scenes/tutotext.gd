extends CanvasLayer
@onready var label: Label = $Label

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		queue_free()
