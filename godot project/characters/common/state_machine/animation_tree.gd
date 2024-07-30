extends AnimationTree

@export var movement_component: Node2D


func transition_to(state_name):
	get("parameters/playback").travel(state_name)


func _process(_delta):
	var movement_direction: Vector2 = movement_component.get_direction()
	if movement_direction != Vector2.ZERO:
		set("parameters/Idle/blend_position", movement_direction)
		set("parameters/Move/blend_position", movement_direction)
