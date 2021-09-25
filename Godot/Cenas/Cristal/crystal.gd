extends Sprite

onready var astar = get_tree().get_root().get_node("Fase1").get_node("A*")
onready var score = get_tree().get_root().get_node("Fase1").get_node("HUD/Score")
var LimitsI = Vector2(2,2)
var LimitsJ = Vector2(13,10)
var x_rand = Vector2()
var y_rand = Vector2()

var rng = RandomNumberGenerator.new()

func _ready():
	$AnimationPlayer.play('crystal')
	generate()
	# Se o tile escolhido não for andável (chão), escolha outro:
	while astar.get_cell(x_rand,y_rand) != 0: 
		generate()
	# Posição final do cristal:
	global_position = astar.map_to_world(Vector2(x_rand,y_rand)) + Vector2(14,12)

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
