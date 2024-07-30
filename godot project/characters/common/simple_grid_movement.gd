extends Node2D

const TILE_SIZE := 32
@export var speed := 2.5
@onready var character := owner as CharacterBody2D
@onready var target_position := character.global_position
var raycast := RayCast2D.new()
var direction := Vector2.ZERO


func _ready():
	add_child(raycast)


func get_direction() -> Vector2:
	return direction


func move(delta: float, new_direction: Vector2) -> bool:
	if character.get_position().distance_to(target_position) > delta * speed:
		if new_direction == (-1) * direction:
			direction = new_direction
			target_position += direction * TILE_SIZE
	else:
		if not test_direction(new_direction):
			return false
		direction = new_direction
		character.set_position(target_position)
		target_position += direction * TILE_SIZE
	
	character.move_and_collide(delta * speed * direction * TILE_SIZE)
	return true


func test_direction(_direction: Vector2) -> bool:
	direction = _direction
	raycast.set_target_position(direction * TILE_SIZE)
	raycast.force_raycast_update()
	return false if raycast.is_colliding() or direction == Vector2.ZERO else true
