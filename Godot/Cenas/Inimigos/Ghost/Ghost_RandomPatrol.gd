extends KinematicBody2D

onready var astar = get_tree().get_root().get_node("Fase1").get_node("A*")
onready var player = get_tree().get_root().get_node("Fase1").get_node("YSort/Player")

export(Texture) var ghostsprite
export(NodePath) var positionset
export(int) var speed
export(int) var radius

onready var ran1 = get_node(str(positionset)+"/R1")
onready var ran2 = get_node(str(positionset)+"/R2")
onready var ran3 = get_node(str(positionset)+"/R3")
onready var ran4 = get_node(str(positionset)+"/R4")
onready var ran5 = get_node(str(positionset)+"/R5")

enum States { FOLLOW, DOUBT, PATROL }
#ESTADOS:
# Follow = Seguindo jogador incessantemente
# Doubt = Estava seguindo, mas o jogador saiu da área próxima. 
# Espera um tempo, depois volta à patrulha.
# Patrol = Patrulha intercalando posições aleatórias 
# entre {ran1, ran2, ran3, ran4, ran5}
var state = States.PATROL
var last_state

var path = []
var tile_size = 32
var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()
var k = 1
var rng = RandomNumberGenerator.new()


func _ready():
	#Inicializar variáveis
	last_position = position
	target_position = position
	
	#Deleta o timer de RANDOM e os raycasts já que não serão usados
	get_node("TimerRandom").queue_free()
	get_node("RayCast").queue_free()
	get_node("RayCast2").queue_free()
	get_node("RayCast3").queue_free()
	get_node("RayCast4").queue_free()
	
	#Atualiza o sprite de acordo com a variável exportada
	get_node("GhostSprite").texture = ghostsprite
	
	#Deleta a CollisionShape2D padrão (caso contrário, buga) e adiciona
	#uma nova com raio maior 'radius'
	get_node("Area2D/CollisionShape2D").queue_free()
	var shape = CircleShape2D.new()
	shape.radius = radius
	var collision = CollisionShape2D.new()
	collision.set_shape(shape)
	get_node("Area2D").add_child(collision)
	

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

#Decide o que fazer no próximo frame, baseado nos possíveis estados
func action():
	match state:
		States.DOUBT:
			#Apaga o caminho atual
			path = []
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
			#Se não estava em patrulha antes, escolher aleatoriamente uma posição ranX e
			#ir até ela. Ao fim, selecionar outra posição ranY aleatoriamente e 
			#ir até ela (loop).
			if last_state != States.PATROL or (last_state == States.PATROL and len(path) == 0):
				rng.randomize()
				var p = rng.randi_range(1, 5)
				match p:
					1:
						_update_navigation_path(global_position, (ran1.global_position))
					2:
						_update_navigation_path(global_position, (ran2.global_position))
					3:
						_update_navigation_path(global_position, (ran3.global_position))
					4:
						_update_navigation_path(global_position, (ran4.global_position))
					5:
						_update_navigation_path(global_position, (ran5.global_position))
				last_state = States.PATROL
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
	#
	var anim_direc
	#Seleciona animação correta com base na direção
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
	#Toca animação correspondente
	get_node("AnimationPlayer").play(anim_direc + "_Walk")
	
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
	#Jogador entrou na Area2D: Segui-lo.
	if body.get_name() == "Player":
		last_state = state
		state = States.FOLLOW
		#Caso o timer de DOUBT esteja em curso, cancelá-lo.
		if !get_node("TimerDoubt").is_stopped():
			get_node("TimerDoubt").stop()

func _on_Area2D_body_exited(body):
	#Jogador saiu da Area2D. Entrar em DOUBT.
	if body.get_name() == "Player":
		last_state = state
		state = States.DOUBT

func _on_TimerDoubt_timeout():
	#Ao fim do timer de DOUBT, caso não houve interrupção, retornar à patrulha.
	if state == States.DOUBT:
		last_state = state
		state = States.PATROL
