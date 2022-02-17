extends CanvasLayer

onready var tween = get_node("Control/Tween")
onready var score = get_node("Control/ScoreRect/Score")
onready var fade_animplayer = get_node("Control/Fade/AnimationPlayer")
export(PackedScene) var minimap_scene
var minimap


func _ready():
	# Adiciona o minimapa correspondente à fase especificada
	minimap = minimap_scene.instance()
	get_node("Control").add_child(minimap)
	# Deixa os itens invisíveis (pois antes da animação ainda estão na tela)
	minimap.visible = false
	score.visible = false
	# Espera um tempo antes de começar a animação
	yield(get_tree().create_timer(0.5), "timeout")
	# Animação minimapa
	tween.interpolate_property(minimap, "rect_position:y", \
	minimap.rect_position.y + 700, minimap.rect_position.y, 1.2, \
	tween.TRANS_BACK, tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.001), "timeout")
	minimap.visible = true
	# Animação score
	tween.interpolate_property(score, "position:y", \
	score.position.y + 500, score.position.y, 1.4, \
	tween.TRANS_BACK, tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.001), "timeout")
	score.visible = true

# Retira o HUD da tela
func finish():
	# Animação minimapa
	tween.interpolate_property(minimap, "rect_position:y", \
	minimap.rect_position.y, minimap.rect_position.y + 500, 0.6, \
	tween.TRANS_BACK, tween.EASE_IN)
	tween.start()
	# Animação score
	tween.interpolate_property(score, "position:y", \
	score.position.y, score.position.y + 300, 0.8, \
	tween.TRANS_BACK, tween.EASE_IN)
	tween.start()

func transition():
	# Toca a animação de transição
	fade_animplayer.play("Fade")
