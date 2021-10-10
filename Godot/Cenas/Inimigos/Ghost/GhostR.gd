extends KinematicBody2D

onready var astar = get_tree().get_root().get_node("Fase1").get_node("A*")
onready var player = get_tree().get_root().get_node("Fase1").get_node("YSort/Player")

onready var posA = get_tree().get_root().get_node("Fase1").get_node("Positions/R/A")
onready var posB = get_tree().get_root().get_node("Fase1").get_node("Positions/R/B")
onready var posC = get_tree().get_root().get_node("Fase1").get_node("Positions/R/C")
onready var ran1 = get_tree().get_root().get_node("Fase1").get_node("Positions/R/R1")
onready var ran2 = get_tree().get_root().get_node("Fase1").get_node("Positions/R/R2")
onready var ran3 = get_tree().get_root().get_node("Fase1").get_node("Positions/R/R3")

onready var RC = get_node("RayCast")
onready var RC2 = get_node("RayCast2")
onready var RC3 = get_node("RayCast3")
onready var RC4 = get_node("RayCast4")

enum States { FOLLOW, DOUBT, RANDOM, PATROL }
#ESTADOS:
# Follow = Seguindo jogador incessantemente
# Doubt = Estava seguindo, mas o jogador saiu do campo de visão. Vai até o
# último local em que o jogador foi visto, espera um tempo. Volta à patrulha.
# Patrol = Patrulha em ciclo (A -> B -> C -> A -> B -> C...)
# Random = De 30 em 30s, escolhe uma posição aleatória entre {ran1,ran2,ran3} 
# e vai até ela (caso não esteja seguindo). Ao fim, volta a patrulhar.
var state = States.PATROL
var last_state

var path = []
export  var speed = 80
var tile_size = 32
var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()
var k = 1
var rng = RandomNumberGenerator.new()
var in_sight = false


func _ready():
	#Inicializar variáveis e estados
	last_position = position
	target_position = position

func _process(delta):
	#Atualizar a posição com base na direção a ser seguida (tile origem -> tile destino)
	global_position += speed * direction * delta
	#Atualizar a posição para o destino, caso se distancie "X" do tile origem
	if position.distance_to(last_position) >= tile_size - speed * delta:
		position = target_position
	#Caso chegue ao tile destino, atualizar a direção e obter o próximo tile destino
	if position == target_position:
		#Decide o que fazer
		action()
		#Calcula a direção do próximo movimento
		set_direction()
		last_position = position
		target_position = position + (direction * tile_size)
	animation()

	#Se o jogador estiver dentro da área 2D
	if in_sight:
		#Lançar 4 raycasts em volta do jogador
		RC.cast_to =  player.global_position - global_position + Vector2(14,14)
		RC2.cast_to =  player.global_position - global_position + Vector2(14,-14)
		RC3.cast_to =  player.global_position - global_position + Vector2(-14,14)
		RC4.cast_to =  player.global_position - global_position + Vector2(-14,-14)
		#Caso algum dos raycasts não colida (tem visão do jogador), seguir o jogador 
		if !RC.is_colliding() or !RC2.is_colliding() or !RC3.is_colliding() or !RC4.is_colliding():
			last_state = state
			state = States.FOLLOW
			#Caso o timer de DOUBT esteja em curso, cancelá-lo.
			if !get_node("TimerDoubt").is_stopped():
				get_node("TimerDoubt").stop()

#Decide o que fazer no próximo frame, baseado nos possíveis estados
func action():
	match state:
		States.DOUBT:
			#Terminar caminho até o jogador. Se terminado, espera um 
			#tempo e retorna à patrulha
			if len(path) == 0:
				#Toca a animação de dúvida
				get_node("AnimationPlayer").play("Doubt")
				#Iniciar o timer para voltar à patrulha
				if get_node("TimerDoubt").is_stopped():   #Impede início em loop
					get_node("TimerDoubt").start()
			return
			
		States.FOLLOW:
			#Caso esteja seguindo, atualizar constantemente o caminho até o jogador
			_update_navigation_path(global_position, player.global_position)
			
		States.PATROL:
			#Se não estava em patrulha antes, calcular qual o ponto mais perto (A, B ou C) e
			#selecioná-lo como início do loop.
			if last_state != States.PATROL:
				var A = global_position.distance_to(posA.global_position)
				var B = global_position.distance_to(posB.global_position)
				var C = global_position.distance_to(posC.global_position)
				var dest = min(min(A,B),C)
				match dest:
					A:
						_update_navigation_path(global_position, posA.global_position)
					B:
						_update_navigation_path(global_position, posB.global_position)
					C:
						_update_navigation_path(global_position, posC.global_position)
				last_state = States.PATROL
			#Caso tenha alcançado o ponto A, ir ao ponto B
			elif global_position == posA.global_position:
				_update_navigation_path(global_position, posB.global_position)
			#Caso tenha alcançado o ponto B, ir ao ponto C
			elif global_position == posB.global_position:
				_update_navigation_path(global_position, posC.global_position)
			#Caso tenha alcançado o ponto C, ir ao ponto A
			elif global_position == posC.global_position:
				_update_navigation_path(global_position, posA.global_position)
			return
			
		States.RANDOM:
			#Caso não estivesse em modo aleatório, escolher um destino aleatoriamente
			if last_state != States.RANDOM:
				rng.randomize()
				var p = rng.randi_range(1, 3)
				match p:
					1:
						_update_navigation_path(global_position, (ran1.global_position))
					2:
						_update_navigation_path(global_position, (ran2.global_position))
					3:
						_update_navigation_path(global_position, (ran3.global_position))
				last_state = States.RANDOM
				return
			#Caso tenha chegado ao destino aleatório, retornar à patrulha
			elif len(path) == 0:
				last_state = state
				state = States.PATROL
			return
			
func set_direction():
	#Se ainda existir caminho, calcular a direção do próximo ponto
	#e excluir esse ponto do caminho.
	if len(path) > 0:
		direction = Vector2(path[0] - global_position).normalized()
		path.remove(0)
	#Se não existir caminho, não há direção.
	else:
		direction = Vector2(0,0)
	

func _update_navigation_path(start_position, end_position):
	# Retorna um PoolVector2Array de pontos que te levam de start_position 
	# até end_position
	path = astar.get_astar_path(start_position, end_position)
	# Caso o caminho seja nulo, retorne
	if len(path) == 0:
		return
	path.remove(0)

func animation():
	#Animação fantasma
	var anim_direc
	var animation
	
	match direction:
		Vector2(0,-1):
			anim_direc = "Up"
		Vector2(0,1):
			anim_direc = "Down"
		Vector2(-1,0):
			anim_direc = "Left"
		Vector2(1,0):
			anim_direc = "Right"
		Vector2(0,0):
			return
	
	animation = anim_direc + "_Walk"
	get_node("AnimationPlayer").play(animation)
	
	#Animação luz
	#Se o fantasma estava dentro do raio (k = 1) e saiu, tocar FadeOut
	if global_position.distance_to(player.global_position) >= 98 && k == 1:
		get_node("AnimationPlayerL").play("Light_FadeOut")
		yield(get_node("AnimationPlayerL"), "animation_finished")
		k = 0
	#Se o fantasma estava fora do raio (k = 0) e entrou, tocar FadeIn
	elif global_position.distance_to(player.global_position) < 98 && k == 0:
		get_node("AnimationPlayerL").play("Light_FadeIn")
		yield(get_node("AnimationPlayerL"), "animation_finished")
		k = 1
	#Se o fantasma permanece dentro do raio (k = 1), tocar Light animação padrão
	elif global_position.distance_to(player.global_position) < 98 && k == 1:
		get_node("AnimationPlayerL").play("Light")


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		in_sight = true

func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		in_sight = false
		if state == States.FOLLOW:
			last_state = state
			state = States.DOUBT


func _on_TimerRandom_timeout():
	print("RandomR")
	#Cancelar ida à posição aleatória caso esteja seguindo o jogador
	if state == States.FOLLOW:
		return
	#Caso o fantasma esteja em DOUBT, aguardar o fim do timer
	elif state == States.DOUBT:
		yield(get_node("TimerDoubt"), "timeout")
	last_state = state
	state = States.RANDOM


func _on_TimerDoubt_timeout():
	#Ao fim do timer de DOUBT, caso não houve interrupção, retornar à patrulha
	if state == States.DOUBT:
		last_state = state
		state = States.PATROL


func _on_Delay_timeout():
	get_node("TimerRandom").start()
	_on_TimerRandom_timeout()
	print("RandomR")
