extends Line2D

onready var level : LevelRoot = Globals.current_level
onready var astar : TileMap = level.get_astar()
onready var player : KinematicBody2D = level.get_player()
onready var exit_position : Vector2 = level.get_exit_position()
var enabled := false
var path : Array


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
	path = astar.get_astar_path(player.global_position, exit_position)
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
