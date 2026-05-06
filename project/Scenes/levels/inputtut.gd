extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match Global.current_device:
			Global.InputDevice.KEYBOARD:
				print("using keyboard UI")
				$jumpa.hide()
				$jumpc.show()
				$movment1.show()
				$movement2.hide()
			Global.InputDevice.GAMEPAD:
				print("using gamepad UI")
				$jumpa.show()
				$jumpc.hide()
				$movment1.hide()
				$movement2.show()
