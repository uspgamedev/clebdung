extends KinematicBody2D

enum States { RANDOM, FOLLOW, PATROL }

onready var astar = get_tree().get_root().get_node("Fase1").get_node("A*")
onready var player = get_tree().get_root().get_node("Fase1").get_node("YSort/Player")

var path = []
var speed = 60
var tile_size = 32
var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()
var k = 0

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
		set_direction()
		last_position = position
		target_position += direction * tile_size
	animation()
	
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
		

func set_direction():
	_update_navigation_path(global_position, player.global_position)
	if len(path) > 1:
		direction = Vector2(path[1] - path[0]).normalized()
	else:
		direction = Vector2(0,0)

func _update_navigation_path(start_position, end_position):
	# Retorna um PoolVector2Array de pontos que te levam de start_position 
	# até end_position
	path = astar.get_astar_path(start_position, end_position)
	# Caso o caminho seja nulo, retorne
	if len(path) == 0:
		return

func animation():
	var anim_direc
	var anim_modo
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
			anim_direc = "Null"
	
	if direction != Vector2(0,0):
		anim_modo = "Walk"
	else:
		anim_modo = "Idle"
		
	animation = anim_direc + "_" + anim_modo 
	get_node("AnimationPlayer").play(animation)

