extends Polygon2D

onready var root_node = find_parent("Level*")
onready var player_mask = root_node.get_node("PlayerMask")
onready var player_reflec = root_node.get_node("PlayerReflection")
onready var player = root_node.get_node("YSort/Player")
onready var tween = get_node("Tween")

# Desativa o input do jogador durante a transição água-terra
func lock_player():
	player.input_enabled = false
	player.direction = Vector2(0,0)
	yield(get_tree().create_timer(.5), "timeout")
	player.input_enabled = true

# Faz a transição terra-água ou vice-versa
func transition(mode, time, delay):
	
	# Posição final da coordernada y do sprite do jogador
	var y_final
	# Valor final do shader do sprite de máscara
	var mask_final
	# Valor final do shader do sprite de reflexão
	var reflection_final
	
	# Atribui valores às variáveis de acordo com a transição
	# mode == 1: Entrando na água
	# mode == -1: Saindo da água
	match mode:
		1:
			mask_final = 0
			reflection_final = .58
			y_final = -8
		-1:
			mask_final = 1
			reflection_final = 0
			y_final = -16
	
	# Interpolação shader do sprite de máscara
	tween.interpolate_property(player_mask.get_material(), \
	"shader_param/mask", player_mask.get_material().get_shader_param("mask"), \
	mask_final, time, 0, Tween.EASE_IN, delay)
	
	# Nesse caso específico é necessário delay na interpolação
	var refdelay = 0
	if mode == 1 and player.target_direction.y == -1:
		refdelay = 0.1
	# Interpolação shader do sprite de reflexão
	tween.interpolate_property(player_reflec.get_material(), \
	"shader_param/mask", player_reflec.get_material().get_shader_param("mask"), \
	reflection_final, time*0.7, 0, Tween.EASE_IN, refdelay)
	
	# Interpolação da posição y do sprite do jogador
	var playerspr_y = player.get_node("PlayerSprite").position.y
	tween.interpolate_property(player.get_node("PlayerSprite"), "position:y", \
	playerspr_y, y_final, time, Tween.EASE_IN)
	
	# Interpolação da velocidade do jogador
	tween.interpolate_property(player, "speed", player.speed, \
	player.speed - mode*40, time, Tween.EASE_IN)
	
	tween.start()

# Jogador entrando na água
func _on_EnterArea2D_body_entered(_body):
	# O delay necessário na interpolação varia de acordo com a direção
	var delay
	match player.target_direction:
		Vector2(0,1):
			delay = 0.05
		Vector2(0,-1):
			delay = 0.2
		_:
			delay = 0.1
	transition(1, 0.3, delay)

# Jogador saindo da água
func _on_ExitArea2D_body_exited(_body):
	transition(-1, 0.17, 0)
