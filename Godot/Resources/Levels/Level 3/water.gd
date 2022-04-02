extends Polygon2D

onready var root_node = find_parent("Level*")
onready var player_sprite = root_node.get_node("PlayerSprite")
onready var player = root_node.get_node("YSort/Player")

func transition(mode, time):
	lock_player()
	var mask_final
	var y_final
	match mode:
		1:
			mask_final = 0.7
			y_final = -8
		-1:
			mask_final = 1
			y_final = -16
			
	$Tween.interpolate_property(player_sprite.get_material(), "shader_param/mask", \
	player_sprite.get_material().get_shader_param("mask"), mask_final, time, \
	Tween.EASE_IN)
	
	var playerspr_y = player.get_node("PlayerSprite").position.y
	$Tween.interpolate_property(player.get_node("PlayerSprite"), "position:y", \
	playerspr_y, y_final, time, Tween.EASE_IN)
	
	$Tween.interpolate_property(player, "speed", player.speed, \
	player.speed - mode*40, time, Tween.EASE_IN)
	
	$Tween.start()


func _on_EnterArea2D_body_entered(_body):
	transition(1, 0.3)

func _on_ExitArea2D_body_exited(_body):
	transition(-1, 0.12)
	
func lock_player():
	player.input_enabled = false
	player.direction = Vector2(0,0)
	yield(get_tree().create_timer(.5), "timeout")
	player.input_enabled = true
	
