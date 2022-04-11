extends Polygon2D

onready var root_node = find_parent("Level*")
onready var player_mask = root_node.get_node("PlayerMask")
onready var player_reflec = root_node.get_node("PlayerReflection")
onready var player = root_node.get_node("YSort/Player")
onready var tween = get_node("Tween")

func lock_player():
	player.input_enabled = false
	player.direction = Vector2(0,0)
	yield(get_tree().create_timer(.5), "timeout")
	player.input_enabled = true

func transition(mode, time, delay):
	lock_player()
	
	var y_final
	var mask_final
	var reflection_final
	
	match mode:
		1:
			mask_final = 0
			reflection_final = .55
			y_final = -8
		-1:
			mask_final = 1
			reflection_final = 0
			y_final = -16
			
	tween.interpolate_property(player_mask.get_material(), \
	"shader_param/mask", player_mask.get_material().get_shader_param("mask"), \
	mask_final, time, 0, Tween.EASE_IN, delay)
	
	var refdelay = 0
	if mode == 1 and player.target_direction.y == -1:
		refdelay = 0.1
	tween.interpolate_property(player_reflec.get_material(), \
	"shader_param/mask", player_reflec.get_material().get_shader_param("mask"), \
	reflection_final, time*0.7, 0, Tween.EASE_IN, refdelay)
	
	var playerspr_y = player.get_node("PlayerSprite").position.y
	tween.interpolate_property(player.get_node("PlayerSprite"), "position:y", \
	playerspr_y, y_final, time, Tween.EASE_IN)
	
	tween.interpolate_property(player, "speed", player.speed, \
	player.speed - mode*40, time, Tween.EASE_IN)
	
	tween.start()


func _on_EnterArea2D_body_entered(_body):
	var delay
	match player.target_direction:
		Vector2(0,1):
			delay = 0.05
		Vector2(0,-1):
			delay = 0.2
		_:
			delay = 0.1
	transition(1, 0.3, delay)

func _on_ExitArea2D_body_exited(_body):
	transition(-1, 0.22, 0)
