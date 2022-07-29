extends Node

const id = "power_up1"
const SPEED_BOOST: float = 3.5
const INTERPOLATION_DURATION: float = 0.4
onready var player: Node2D = get_node("../../../")
onready var player_sprite: Node2D = player.get_sprite()


func use_power_up():
	yield(player.interpolate_speed(INTERPOLATION_DURATION*0.9, SPEED_BOOST, 0, 1), "completed")
	yield(player.interpolate_speed(INTERPOLATION_DURATION*0.1, 1/SPEED_BOOST, 0, 0), "completed")
	queue_free()


func _process(_delta):
	$Sprite.global_position = player_sprite.global_position
	$Sprite.frame = player_sprite.frame
