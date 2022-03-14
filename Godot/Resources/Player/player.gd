extends KinematicBody2D

export(int) var speed = 85
var tile_size = 32

var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()
var old_direction = Vector2()
var target_direction = Vector2()

var input_enabled = false

func _ready():
	#Inicializar variáveis
	last_position = position
	target_position = position


func _process(_delta):
	animation()

"""
func _physics_process(delta): 
	#MOVENDO
	#Colisão
	if $PlayerRayCast.is_colliding():
		position = last_position
		target_position = position
	else:
		#Mover-se
		move_and_collide(speed * direction * delta)
		
		if position.distance_to(last_position) >= tile_size - speed * delta:
			position = target_position
	
	#PARADO
	if position == target_position:
		set_direction()
		last_position = position
		target_position += direction * tile_size
"""

func _physics_process(delta):
	# Salva a última direção e atualiza o parâmetro
	old_direction = direction
	set_direction()
	
	# Caso o jogador NÂO esteja na posição alvo,
	if position.distance_to(target_position) > 1:
		# e a nova direção for nula, seguir na última direção (até o destino)
		if direction == Vector2(0,0):
			direction = old_direction
		# e tente reverter o movimento em algum eixo, o alvo é atualizado
		if (old_direction.x != direction.x and old_direction.y == direction.y) \
		or (old_direction.y != direction.y and old_direction.x == direction.x):
			target_position += direction * tile_size
	# Caso esteja,
	else:
		# atualiza a posição exata do jogador (evita bugs)
		position = target_position
		# atualiza a posição alvo de acordo com a direção
		target_position += direction * tile_size
	
	# Calcula a direção que o jogador deve seguir para alcançar o alvo
	target_direction = (target_position - position).round().normalized()
	# Caso a direção ao alvo seja não nula, lançar raycast
	if target_direction != Vector2(0,0):
		$PlayerRayCast.cast_to = target_direction * tile_size/2
	# Atualiza o raycast e checa por colisões, anulando movimentos
	$PlayerRayCast.force_raycast_update()
	if $PlayerRayCast.is_colliding():
		target_position = position
		target_direction = Vector2(0,0)
	# Mover-se
	move_and_collide(speed * target_direction * delta)

func set_direction():
	# Determinar direção do movimento
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")

	if input_enabled:
		direction.x = int(RIGHT) - int(LEFT)
		direction.y = int(DOWN) - int(UP)
	
	# Impedir movimento diagonal
	if direction.x != 0 && direction.y != 0:
		direction = Vector2(0,0)
	

func animation():
	var anim_direc
	var anim_mode
	var animation
	
	match $PlayerRayCast.cast_to.normalized():
		Vector2(0,-1):
			anim_direc = "Up"
		Vector2(0,1):
			anim_direc = "Down"
		Vector2(-1,0):
			anim_direc = "Left"
		Vector2(1,0):
			anim_direc = "Right"
		Vector2(0,0):
			anim_direc = "Null"
	
	if target_direction != Vector2(0,0):
		anim_mode = "Walk"
	else:
		anim_mode = "Idle"
		
	animation = anim_direc + "_" + anim_mode
	get_node("AnimationPlayer").play(animation)

func die():
	#get_tree().reload_current_scene()
	$PlayerCollision.disabled = true
	yield(get_tree().create_timer(.5), "timeout")
	$PlayerCollision.disabled = false
