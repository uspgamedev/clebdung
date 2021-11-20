extends Sprite

onready var fase = find_parent("Fase*")
onready var astar = fase.get_node("A*")
onready var score = fase.get_node("HUD/Score")
onready var player = fase.get_node("YSort/Player")
export(Vector2) var LimitsI
export(Vector2) var LimitsJ
export(Vector2) var Offset
export(bool) var Fixed
var x_rand = Vector2()
var y_rand = Vector2()

var rng = RandomNumberGenerator.new()

func _ready():
	# Se o cristal não é um cristal fixo, gerar posição aleatória
	if not Fixed:
		generate()
		# Se o tile escolhido não for andável (chão), escolha outro:
		while astar.get_cell(x_rand,y_rand) != 0: 
			generate()
		# Posição final do cristal:
		global_position = astar.map_to_world(Vector2(x_rand,y_rand)) + Offset

func generate():
	# Escolhe aleatoriamente um tile aleatório dentro dos limites predefinidos:
	rng.randomize()
	x_rand = int(rng.randf_range(LimitsI.x, LimitsJ.x))
	y_rand = int(rng.randf_range(LimitsI.y, LimitsJ.y))

func _on_Area2D_body_entered(body):
	# Caso o jogador "colida" com o cristal, apague-o do mapa e incremente o score:
	if body.get_name() == "Player":
		score.update_score()
		queue_free()
