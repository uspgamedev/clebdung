extends State


func physics_update(_delta: float) -> void:
	if (
		Input.get_action_strength("right")
		or Input.get_action_strength("left")
		or Input.get_action_strength("down")
		or Input.get_action_strength("up")
	):
		state_machine.transition_to("Move")
