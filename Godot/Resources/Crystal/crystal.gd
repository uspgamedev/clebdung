extends Sprite

onready var root_node = find_parent("Level*")
onready var score = root_node.get_node("HUD/Control/ScoreRect/Score")
onready var player = root_node.get_node("YSort/Player")
onready var animplayer = get_node("AnimationPlayer")
export(Vector2) var Offset
var d

var rng = RandomNumberGenerator.new()

func _ready():
	animplayer.stop()

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
