extends Node
class_name StateMachine

# Emitted when transitioed to a new state.
signal transitioned(state_name)

@export_node_path var initial_state := NodePath()
@onready var state: State = get_node(initial_state)


func _ready() -> void:
	for child in get_children():
		child.state_machine = self
	await (owner.ready)
	state.enter()


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
		
	var old_state := state
	state.exit()
	state = get_node(target_state_name)
	if state.enter(msg):
		emit_signal("transitioned", state.name)
	else:
		state = old_state
		state.enter(msg)
