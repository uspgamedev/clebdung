extends Node2D

onready var animPlayer = get_node("AnimationPlayer")
onready var astar = get_tree().get_root().get_node("Level2/A*")
onready var player = get_parent().get_node("Player")
var k = 0
var on_stairs = false
var on_area = false

func _process(_delta):
	# Desbloqueia a saída e retira o Astar onde o bloco é movido
	if on_area and k == 0 and \
	animPlayer.get_current_animation() == "Unblocked":
		animPlayer.play("WinAnimation")
		# O Astar é retirado "em cima da hora" e gradualmente, 
		# para evitar bugs	
		yield(get_tree().create_timer(1.0), "timeout")
		for x in [16,15,17]:
			astar.set_cell(x,18,1)
			astar._ready()
			yield(get_tree().create_timer(0.4), "timeout")
		k = 1
	# Caso o jogador esteja andando em direção às escadas
	# após o desbloqueio, encerrar fase
	if on_stairs and player.direction == Vector2(0,1):
		get_tree().get_root().get_node("Level2").win()
		
func _on_AnimArea2D_body_entered(_body):
	# (Área só funciona após coleta dos cristais)
	on_area = true

func _on_AnimationPlayer_animation_changed(old_name, _new_name):
	# Ativa Astar próximo à escada após desbloqueio da saída
	if old_name == "WinAnimation":
		for x in range (15,18):
			for y in range (15,17):
				if x != 16 or y != 16:
					astar.set_cell(x,y,0)
		astar._ready()

# (Área só funciona após desbloqueio da saída)
func _on_StairsArea2D_body_entered(_body):
	on_stairs = true

# (Área só funciona após desbloqueio da saída)
func _on_StairsArea2D_body_exited(_body):
	on_stairs = false


func _on_AnimArea2D_body_exited(_body):
	on_area = false
