extends Sprite

onready var fase = find_parent("Fase*")
onready var id = fase.get_node("CristaisID")
onready var score = fase.get_node("HUD/Control/ScoreRect/Score")
onready var player = fase.get_node("YSort/Player")
onready var animplayer = get_node("AnimationPlayer")
export(Vector2) var Offset
export(Vector2) var MapSize
export(bool) var Fixed
export(int) var CristalID
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
		while id.get_cell(x_rand,y_rand) != CristalID - 1: 
			generate()
		# Posição final do cristal:
		global_position = id.map_to_world(Vector2(x_rand,y_rand)) + Offset

func generate():
	# Escolhe aleatoriamente um tile aleatório dentro dos limites predefinidos:
	rng.randomize()
	x_rand = int(rng.randi_range(0, MapSize.x))
	y_rand = int(rng.randf_range(0, MapSize.y))

func _on_Area2D_body_entered(body):
	# Caso o jogador "colida" com o cristal, apague-o do mapa e incremente o score:
	if body.get_name() == "Player":
		score.update_score()
		queue_free()

func _process(_delta):
	d = global_position.distance_to(player.global_position)
	# Se a distância até o jogador for pequena
	if d < 140:
		# Se a distância até o jogador for MUITO pequena
		if d < 90:
			if animplayer.is_playing() and animplayer.current_animation != "Crystal":
				# Espera terminar animação anterior, caso houver
				yield(animplayer, "animation_finished")
			# Animação padrão
			animplayer.play("Crystal")
		# Caso contrário
		else:
			if animplayer.is_playing() and animplayer.current_animation != "Crystal_Light":
				# Espera terminar animação anterior, caso houver
				yield(animplayer, "animation_finished")
			# Animação de dica
			animplayer.play("Crystal_Light")
	# Caso contrário, parar animações
	else:
		if animplayer.is_playing():
			yield(animplayer, "animation_finished")
		animplayer.stop()
