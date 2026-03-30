extends State
class_name FiniteStateMachine

var states: Dictionary={}
var current_state : State
@export var initial_state:State
@export var Player:player

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	
	if initial_state:
		initial_state.parent = Player
		initial_state.Enter()
		current_state = initial_state

func process_input(event: InputEvent):
	if current_state:
		current_state.process_input(event)
func process(delta:float):
	if current_state:
		current_state.process(delta)
func process_physics(delta:float):
	if current_state:
		current_state.process_physics(delta)

func change_state(source_state:State, new_state_name:String):
	if source_state != current_state:
		push_error("Invalid change state trying from: ",source_state,"but currently in:
			",current_state)
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		push_error("New state is empty")
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.parent = Player
	new_state.Enter()
	current_state=new_state
