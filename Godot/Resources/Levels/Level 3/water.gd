extends Polygon2D

onready var root_node = find_parent("Level*")
onready var player_mask = root_node.get_node("PlayerMask")
onready var player_reflec = root_node.get_node("PlayerReflection")
onready var player = root_node.get_node("YSort/Player")
onready var player_raycast = player.get_node("PlayerRayCast")
onready var tween = get_node("Tween")
var space_state
var in_water = false
var exiting = false


func _ready():
	# Atribui o formato do polígono à Area2D
	$Area2D/CollisionPolygon2D.polygon = polygon
	# Acesso ao espaço 2D ocupado pela Area2D
	space_state = $Area2D.get_world_2d().direct_space_state


func _process(_delta):
	# Se o jogador estiver dentro d'água e não estiver efetivamente saindo
	if in_water and not exiting:
		# Checar se o jogador está saindo agora da água
		if player_exiting():
			# Transicionar
			exiting = true
			transition(-1, 0.17, 0)

# Checa se o jogador está saindo da água verificando se a ponta do raycast do
# jogador está fora da água (Area2D) e se o jogador está se movendo, simultaneamente
func player_exiting():
	# Ponta do raycast
	var raycast_endpoint = player_raycast.global_position + player_raycast.get_cast_to()
	# Verificação das condições simultâneas
	if not space_state.intersect_point(raycast_endpoint, 1, [], 2, false, true) \
	and player.target_direction != Vector2(0,0):
		return true
	return false

# Desativa o input do jogador durante a transição água-terra
func lock_player(time):
	player.input_enabled = false
	player.direction = Vector2(0,0)
	yield(get_tree().create_timer(time), "timeout")
	player.input_enabled = true

# Faz a transição terra-água ou vice-versa
func transition(mode, time, delay):
	# Trava o jogador durante a transição
	lock_player(time + delay)
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
			reflection_final = 0.58
			y_final = -8
		-1:
			mask_final = 1
			reflection_final = 0
			y_final = -16
	
	# Interpolação shader do sprite de máscara
	tween.interpolate_property(player_mask.get_material(), \
	"shader_param/mask", player_mask.get_material().get_shader_param("mask"), \
	mask_final, time, 0, Tween.EASE_IN, delay)
	
	
	# Interpolação shader do sprite de reflexão
	var refdelay = delay
	tween.interpolate_property(player_reflec.get_material(), \
	"shader_param/mask", player_reflec.get_material().get_shader_param("mask"), \
	reflection_final, time*0.5, 0, Tween.EASE_IN, refdelay)
	
	# Interpolação da posição y do sprite do jogador
	var playerspr_y = player.get_node("PlayerSprite").position.y
	tween.interpolate_property(player.get_node("PlayerSprite"), "position:y", \
	playerspr_y, y_final, time, Tween.EASE_IN, delay)
	
	# Interpolação da velocidade do jogador
	tween.interpolate_property(player, "speed", player.speed, \
	player.speed - mode*40, time, Tween.EASE_IN, delay)

	tween.start()

# Jogador entrando na água
func _on_EnterArea2D_body_entered(_body):
	# O delay necessário na interpolação varia de acordo com a direção
	var delay
	match player.target_direction:
		Vector2(0,1):
			delay = 0.05
		Vector2(0,-1):
			delay = 0.33
		_:
			delay = 0.12
	var raycast_endpoint = player_raycast.global_position + player_raycast.get_cast_to()
	if space_state.intersect_point(raycast_endpoint, 1, [], 2, false, true):
		in_water = true
		transition(1, 0.3, delay)

# Jogador saiu completamente da água
func _on_Area2D_body_exited(_body):
	exiting = false
	in_water = false
