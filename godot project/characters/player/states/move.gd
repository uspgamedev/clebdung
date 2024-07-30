extends State

@export var movement_component: Node2D


func enter(_msg := {}) -> bool:
	return movement_component.test_direction(get_input_direction())


func physics_update(delta: float) -> void:
	if not movement_component.move(delta, get_input_direction()):
		state_machine.transition_to("Idle")


func get_input_direction() -> Vector2:
	var direction := Vector2.ZERO
	var x_input := Input.get_axis("left", "right")
	var y_input := Input.get_axis("up", "down")
	
	if abs(x_input) > abs(y_input):
		direction.x = x_input
	else:
		direction.y = y_input
	
	return direction
