extends KinematicBody2D

"""
ESTADOS:
- Follow = Seguindo jogador incessantemente
- Doubt = Estava seguindo, mas o jogador saiu do campo de visão. Vai até o
último local em que o jogador foi visto, espera um tempo. Volta à patrulha.
- Patrol = Patrulha em ciclo (A -> B -> C -> A -> B -> C...)
- Random = De 30 em 30s, escolhe uma posição aleatória entre {ran1,ran2,ran3} 
e vai até ela (caso não esteja seguindo). Ao fim, volta a patrulhar. 
"""
enum States { FOLLOW, DOUBT, PATROL, RANDOM }

"""
TIPOS:
- Default = Patrulha entre A, B e C, ocasionalmente indo até uma posição
aleatória dentre R1, R2 e R3.
- Random Patrol = Patrulha aleatóriamente entre as posições R1, R2, R3,
R4 e R5.
- Only Patrol = Apenas patrulha entre A,B e C, nada mais. 
"""
enum Types { DEFAULT, RANDOM_PATROL, ONLY_PATROL }
export(Types) var type

const TILE_SIZE := 32
export(NodePath) var positionset
export(int) var speed
var state = States.PATROL
var last_state
var path := []
var direction := Vector2()
var last_position := Vector2()
var target_position := Vector2()
var k := 0
var rng := RandomNumberGenerator.new()
var in_sight := false
var chaos := false
var has_to_change_to_random := false
onready var level : LevelRoot = Globals.current_level
onready var astar : TileMap = level.get_astar()
onready var player : KinematicBody2D = level.get_player()
onready var animplayerL := get_node("AnimationPlayerL")
onready var RC1 := get_node("RayCast")
onready var RC2 := get_node("RayCast2")
onready var RC3 := get_node("RayCast3")
onready var RC4 := get_node("RayCast4")

# Variáveis dependentes do tipo de fantasma
var posA : Vector2
var posB : Vector2
var posC : Vector2
var ran1 : Vector2
var ran2 : Vector2
var ran3 : Vector2
var ran4 : Vector2
var ran5 : Vector2
export(int) var delayrandom
export(int) var radius


func _ready():
	add_to_group("Ghosts")
	# Corrige a cor da luz do fantasma baseado na textura
	var texture = get_node("GhostSprite").get_texture().get_data()
	texture.lock()
	var color = texture.get_pixel(13,37)
	texture.unlock()
	get_node("Light2D").color = color
	get_node("Light2D/SpriteLight (Correção)").modulate = color
	get_node("Light2D/SpriteLight (Correção)").modulate.a = 0.1176
	
	# Inicializar variáveis
	last_position = position
	target_position = position
	
	# Define variáveis de acordo com o tipo de fantasma
	match type:
		Types.DEFAULT:
			# Estabelece o tempo de delay para o RANDOM iniciar, e inicia o timer de delay
			get_node("TimerRandom/Delay").set_wait_time(delayrandom)
			get_node("TimerRandom/Delay").start()
			
			# Importa posições
			posA = get_node(str(positionset)+"/A").global_position
			posB = get_node(str(positionset)+"/B").global_position
			posC = get_node(str(positionset)+"/C").global_position
			ran1 = get_node(str(positionset)+"/R1").global_position
			ran2 = get_node(str(positionset)+"/R2").global_position
			ran3 = get_node(str(positionset)+"/R3").global_position

		Types.RANDOM_PATROL:
			# Delete o timer de RANDOM já que não será usado
			get_node("TimerRandom").queue_free()
			
			# Deleta a CollisionShape2D padrão (caso contrário, buga a dos outros
			# fantasmas) e adiciona uma nova com raio maior 'radius'
			get_node("Vision/CollisionShape2D").queue_free()
			var shape = CircleShape2D.new()
			shape.radius = radius
			var collision = CollisionShape2D.new()
			collision.set_shape(shape)
			get_node("Vision").add_child(collision)
			
			# Importa posições			
			ran1 = get_node(str(positionset)+"/R1").global_position
			ran2 = get_node(str(positionset)+"/R2").global_position
			ran3 = get_node(str(positionset)+"/R3").global_position
			ran4 = get_node(str(positionset)+"/R4").global_position
			ran5 = get_node(str(positionset)+"/R5").global_position
		
		Types.ONLY_PATROL:
			# Delete o timer de RANDOM já que não será usado
			get_node("TimerRandom").queue_free()

			# Importa posições
			posA = get_node(str(positionset)+"/A").global_position
			posB = get_node(str(positionset)+"/B").global_position
			posC = get_node(str(positionset)+"/C").global_position


func _process(_delta):
	# Seguir incessantemente caso esteja em estado de caos
	if chaos:
		switch_state(States.FOLLOW)
	animation()


func _physics_process(delta):
	# Mover com base na direção a ser seguida (tile origem -> tile destino)
	# e checar possível colisão com o jogador
	if move_and_collide(speed * direction * delta):
		player.die()
	# Atualizar a posição para o destino, caso se distancie "X" do tile origem
	if position.distance_to(last_position) >= TILE_SIZE - speed * delta:
		position = target_position
	# Caso chegue ao tile destino, atualizar a direção e obter o próximo tile destino
	if position == target_position:
		# Decide o que fazer
		action()
		# Calcula a direção do próximo movimento
		set_direction()
		
	# Se o jogador estiver dentro da área 2D
	if in_sight:
		# Lançar 4 raycasts em volta do jogador e atualizar as informações de colisão
		var offset: int = 14
		RC1.cast_to  = player.global_position - global_position + Vector2( offset, offset)
		RC2.cast_to =  player.global_position - global_position + Vector2( offset,-offset)
		RC3.cast_to =  player.global_position - global_position + Vector2(-offset, offset)
		RC4.cast_to =  player.global_position - global_position + Vector2(-offset,-offset)
		RC1.force_raycast_update()
		RC2.force_raycast_update()
		RC3.force_raycast_update()
		RC4.force_raycast_update()
		# Caso algum dos raycasts não colida (tem visão do jogador), seguir o jogador 
		if !RC1.is_colliding() or !RC2.is_colliding() or !RC3.is_colliding() or !RC4.is_colliding():
			switch_state(States.FOLLOW)
			# Caso o timer de DOUBT esteja em curso, cancelá-lo.
			if !get_node("TimerDoubt").is_stopped():
				get_node("TimerDoubt").stop()

# Decide o que fazer no próximo frame, baseado nos possíveis estados
func action():
	match state:
		States.DOUBT:
			# Toca a animação de dúvida
			if len(path) != 0:
				return
			get_node("AnimationPlayer").play("Doubt")
			# Iniciar o timer para voltar à patrulha
			if get_node("TimerDoubt").is_stopped():   		#Impede início em loop
				get_node("TimerDoubt").start()
			return
			
		States.FOLLOW:
			# Caso esteja seguindo, atualizar constantemente o caminho até o jogador
			_update_navigation_path(global_position, player.global_position)
			
		States.PATROL:
			# Realiza a patrulha específica de cada tipo de fantasma
			match type:
				Types.DEFAULT, Types.ONLY_PATROL:
					# Se não estava em patrulha antes, calcular qual o ponto mais perto (A, B ou C) e
					# selecioná-lo como início do loop.
					if last_state != States.PATROL:
						var A = global_position.distance_to(posA)
						var B = global_position.distance_to(posB)
						var C = global_position.distance_to(posC)
						var dest = min(min(A,B),C)
						match dest:
							A:
								_update_navigation_path(global_position, posA)
							B:
								_update_navigation_path(global_position, posB)
							C:
								_update_navigation_path(global_position, posC)
						switch_state(state)
					# Caso tenha alcançado o ponto A, ir ao ponto B
					elif global_position == posA:
						_update_navigation_path(global_position, posB)
					# Caso tenha alcançado o ponto B, ir ao ponto C
					elif global_position == posB:
						_update_navigation_path(global_position, posC)
					# Caso tenha alcançado o ponto C, ir ao ponto A
					elif global_position == posC:
						_update_navigation_path(global_position, posA)
					return

				Types.RANDOM_PATROL:
					# Se não estava em patrulha antes, escolher aleatoriamente uma posição ranX e
					# ir até ela. Ao fim, selecionar outra posição ranY aleatoriamente e 
					# ir até ela (loop).
					if last_state != States.PATROL or (last_state == States.PATROL and len(path) == 0):
						rng.randomize()
						var p = rng.randi_range(1, 5)
						match p:
							1:
								_update_navigation_path(global_position, (ran1))
							2:
								_update_navigation_path(global_position, (ran2))
							3:
								_update_navigation_path(global_position, (ran3))
							4:
								_update_navigation_path(global_position, (ran4))
							5:
								_update_navigation_path(global_position, (ran5))
						switch_state(state)
					return
			
		States.RANDOM:
			# Caso não estivesse em modo aleatório, escolher um destino aleatoriamente
			if last_state != States.RANDOM:
				rng.randomize()
				var p = rng.randi_range(1, 3)
				match p:
					1:
						_update_navigation_path(global_position, (ran1))
					2:
						_update_navigation_path(global_position, (ran2))
					3:
						_update_navigation_path(global_position, (ran3))
				switch_state(state)
				return
			# Caso tenha chegado ao destino aleatório, retornar à patrulha
			elif len(path) == 0:
				switch_state(States.PATROL)
			return


func set_direction():
	# Se ainda existir caminho, calcular a direção do próximo ponto
	# e excluir esse ponto do caminho.
	if len(path) > 0:
		direction = Vector2(path[0] - global_position).normalized()
		last_position = position
		target_position = path[0]
		path.remove(0)
	else:
		direction = Vector2(0, 0)


func _update_navigation_path(start_position, end_position):
	# Retorna um PoolVector2Array de pontos que te levam de start_position 
	# até end_position
	path = astar.get_astar_path(start_position, end_position)
	# Caso o caminho seja nulo, retorne
	if len(path) == 0:
		return
	path.remove(0)


func animation():
	# ANIMAÇÃO DO FANTASMA
	# Animação movimento
	var anim_name
	# Seleciona animação correta com base na direção
	match direction:
		Vector2(0,-1):
			anim_name = "Up_Walk"
		Vector2(0,1):
			anim_name = "Down_Walk"
		Vector2(-1,0):
			anim_name = "Left_Walk"
		Vector2(1,0):
			anim_name = "Right_Walk"
		Vector2(0,0):
			anim_name = "Doubt"
			
	if anim_name == null:
		return
	# Toca animação correspondente
	get_node("AnimationPlayer").play(anim_name)

	# Animação luz
	if state == States.FOLLOW:
		if k == 0:
			# Caso o fantasma começado a seguir agora, "iniciar" luz
			k = 1
			animplayerL.play("Light_FadeIn")
	else:
		if k == 1:
			# Caso o fantasma tenha parado de seguir, "retirar" luz
			k = 0
			animplayerL.play("Light_FadeOut")

	# Animação caos
	if chaos:
		animplayerL.play("Light_Chaos")
		return	

func switch_state(new_state):
	last_state = state
	state = new_state

func _on_Vision_body_entered(body):
	# Jogador entrou na Area2D. Pode ser visto (in_sight)
	if body.get_name() == "Player":
		in_sight = true


func _on_Vision_body_exited(body):
	# Jogador saiu da Area2D. Entrar em DOUBT caso estivesse seguindo
	if body.get_name() == "Player":
		in_sight = false
		if state == States.FOLLOW:
			switch_state(States.DOUBT)


func _on_TimerDoubt_timeout():
	# Ao fim do timer de DOUBT, caso não houve interrupção, retornar à patrulha
	if state == States.DOUBT:
		if has_to_change_to_random:
			has_to_change_to_random = false
			switch_state(States.RANDOM)
		else:
			switch_state(States.PATROL)


# Chamada pelo próprio nó Score
func f_chaos():
	chaos = not chaos


func _on_TimerRandom_timeout():
	# Cancelar ida à posição aleatória caso esteja seguindo o jogador
	if state == States.FOLLOW:
		return
	# Caso o fantasma esteja em DOUBT, aguardar o fim do timer
	elif state == States.DOUBT:
		has_to_change_to_random = true
	# Mude imediatamente
	else:
		switch_state(States.RANDOM)


func _on_Delay_timeout():
	# Ao fim do delay, iniciar timer de RANDOM e entrar no próprio estado RANDOM
	get_node("TimerRandom").start()
	_on_TimerRandom_timeout()
		
