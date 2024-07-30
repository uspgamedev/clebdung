extends Node
class_name State

var state_machine: StateMachine


func handle_input(_event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass


func enter(_msg := {}) -> bool:
	return true


func exit() -> void:
	pass
