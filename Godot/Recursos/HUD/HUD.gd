extends CanvasLayer

onready var tween = get_node("Control/Tween")
onready var score = get_node("Control/ScoreRect/Score")
export(PackedScene) var minimapa_caminho
var minimapa


func _ready():
	# Adiciona o minimapa correspondente à fase especificada
	minimapa = minimapa_caminho.instance()
	get_node("Control").add_child(minimapa)
	# Deixa os itens invisíveis (pois antes da animação ainda estão na tela)
	minimapa.visible = false
	score.visible = false
	# Espera um tempo antes de começar a animação
	yield(get_tree().create_timer(0.5), "timeout")
	# Animação minimapa
	tween.interpolate_property(minimapa, "rect_position:y", \
	minimapa.rect_position.y + 700, minimapa.rect_position.y, 1.2, \
	tween.TRANS_BACK, tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.001), "timeout")
	minimapa.visible = true
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
	tween.interpolate_property(minimapa, "rect_position:y", \
	minimapa.rect_position.y, minimapa.rect_position.y + 500, 0.6, \
	tween.TRANS_BACK, tween.EASE_IN)
	tween.start()
	# Animação score
	tween.interpolate_property(score, "position:y", \
	score.position.y, score.position.y + 300, 0.8, \
	tween.TRANS_BACK, tween.EASE_IN)
	tween.start()
