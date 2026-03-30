extends State
class_name PlayerIdle

func Enter():
	print("idle inter")


func process_input(event: InputEvent):
	if Input.get_axis("ui_left","ui_right"):
		state_transition.emit(self, "movement")

func Exit():
	print("idle exit")
