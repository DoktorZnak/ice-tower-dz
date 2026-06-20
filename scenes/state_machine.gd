class_name StateMachine extends Node

@export var initial_state: State = null

# state to np klasa Idle, Running, Jumping, Falling
@onready var state: State = (func get_initial_state():return initial_state if initial_state != null else get_child(0)).call()

func _ready():
	for state_node in get_children():
		if state_node is State:
			state_node.finished.connect(_transition_to_next_state)
	
	await owner.ready
	state.enter("")
	
func _unhandled_input(event: InputEvent):
	state.handle_input(event)
	
func _process(delta: float):
	state.update(delta)

func _physics_process(delta: float):
	state.physics_update(delta)

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}):
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return
	
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
