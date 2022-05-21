extends Node

const SPEED_BOOST: float = 2.5
const INTERPOLATION_DURATION: float = 0.5
onready var player: Node2D = get_node("../../../")
onready var player_sprite: Node2D = player.get_sprite()


func use_power_up():
	$Tween.stop_all()
	$Tween.interpolate_property(player, "speed", SPEED_BOOST * player.speed, 
								player.speed, INTERPOLATION_DURATION, 
								Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.call_deferred("start")
	yield($Tween, "tween_completed")
	queue_free()


func get_duration():
	return INTERPOLATION_DURATION


func _process(_delta):
	$Sprite.global_position = player_sprite.global_position
	$Sprite.frame = player_sprite.frame
