extends Sprite

onready var fase = find_parent("Fase*")
onready var astar = fase.get_node("A*")
onready var score = fase.get_node("HUD/Control/ScoreRect/Score")
onready var player = fase.get_node("YSort/Player")
onready var animplayer = get_node("AnimationPlayer")
export(Vector2) var LimitsI
export(Vector2) var LimitsJ
export(Vector2) var Offset
export(bool) var Fixed
var x_rand = Vector2()
var y_rand = Vector2()
var d

var rng = RandomNumberGenerator.new()

func _ready():
	animplayer.stop()
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

func _process(_delta):
	animation()
		
func animation():
	d = global_position.distance_to(player.global_position)
	# Se a distância até o jogador for pequena
	if d < 140:
		# Se a distância até o jogador for MUITO pequena
		if d < 90:
			if animplayer.is_playing() and animplayer.current_animation != "Crystal":
				yield(animplayer, "animation_finished")
			animplayer.play("Crystal")
		# Caso contrário
		else:
			if animplayer.is_playing() and animplayer.current_animation != "Crystal_Light":
				yield(animplayer, "animation_finished")
			animplayer.play("Crystal_Light")
	# Caso contrário, parar animações
	else:
		animplayer.stop()
