extends Node

# Velocidade padrão do player
var player_base_speed: int = 0

var speed_boost: float = 2.0
var interpolation_duration: float = 0.8

func _process(delta):
	if Input.is_action_just_pressed("dash"):
		var player = get_parent()
		$Tween.stop_all()
		$Tween.interpolate_property(player, "speed",
									speed_boost * player_base_speed, player_base_speed,
									interpolation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.call_deferred("start")

func set_base_speed(spd: int):
	player_base_speed = spd
