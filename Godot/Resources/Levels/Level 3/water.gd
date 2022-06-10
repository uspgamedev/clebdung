extends Polygon2D

onready var level : LevelRoot = Globals.current_level
onready var player : KinematicBody2D = level.get_player()
onready var player_raycast : RayCast2D = player.get_raycast()
onready var player_mask : Sprite = level.get_player_mask()
onready var player_reflec : Sprite = level.get_player_reflection()
var space_state : Physics2DDirectSpaceState
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


# Faz a transição terra-água ou vice-versa
func transition(mode, time, delay):
	# Trava o jogador durante a transição
	player.lock_player(time + delay)
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
	player_mask.interpolate_shader(mask_final, time, delay)
	
	# Interpolação shader do sprite de reflexão
	player_reflec.interpolate_shader(reflection_final, time*0.5, delay)
	
	# Interpolação da posição no eixo y do sprite do jogador
	var playerspr_y = player.get_sprite().position.y
	$Tween.interpolate_property(player.get_sprite(), "position:y", \
	playerspr_y, y_final, time, Tween.EASE_IN, delay)
	
	# Interpolação da velocidade do jogador
	player.interpolate_speed(time, 0.5 if mode == 1 else 2, delay, 0, 0)
	
	$Tween.start()

# Jogador entrando na água
func _on_EnterArea2D_body_entered(body):
	if body.get_name() == "Player":
		# O delay necessário na interpolação varia de acordo com a direção
		var delay
		match player.get_direction():
			Vector2(0,1):
				delay = 0.05
			Vector2(0,-1):
				delay = 0.2
			_:
				delay = 0.12
		var raycast_endpoint = player_raycast.global_position + player_raycast.get_cast_to()
		if space_state.intersect_point(raycast_endpoint, 1, [], 2, false, true):
			in_water = true
			transition(1, 0.3, delay)

# Jogador saiu completamente da água
func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		exiting = false
		in_water = false
