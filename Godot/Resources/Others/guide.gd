extends Line2D

onready var level = find_parent("Level*")
onready var astar = level.get_node("A*")
onready var player = level.get_node("YSort/Player")
export(NodePath) var exit_path
onready var exit = get_node(exit_path)
var enabled = false
var path

func _process(_delta):
	if enabled:
		# Desenha com os pontos atuais
		draw()
		# Pausa para evitar atualização instantânea do caminho
		set_process(false)
		yield(get_tree().create_timer(3), "timeout")
		set_process(true)
	
func draw():
	clear_points()
	# Calcula o caminho entre o jogador e a saída
	path = astar.get_astar_path(player.global_position, exit.global_position)
	# Caso o caminho seja nulo, retorne
	if len(path) == 0:
		return
	# Atualiza os pontos do nó Line2D
	for point in path:
		add_point(point)
		yield(get_tree().create_timer(0.025), "timeout")
	
func enable():
	enabled = true
	$AnimationPlayer.play("Fade")

func disable():
	enabled = false
