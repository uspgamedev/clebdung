extends CanvasLayer

onready var tween = get_node("Control/Tween")
onready var score = get_node("Control/ScoreRect/Score")
onready var levelname = get_node("Control").get_node("LevelName")
export(PackedScene) var minimap_scene
export(String) var scene_name
var minimap

func _ready():
	display_name()

# Mostra o nome da fase
func display_name():
	# Define o texto do  nó para o nome da fase correspondente
	levelname.bbcode_text = "[center][u]" + \
	scene_name + "[/u][/center]"
	# Animação de aparecimento
	tween.interpolate_property(levelname, "modulate", \
	Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.5, \
	Tween.TRANS_LINEAR)
	yield(get_tree().create_timer(0.3), "timeout")
	tween.start()

# Retira o nome da fase
func undisplay_name():
	# Animação de desaparecimento
	tween.interpolate_property(levelname, "modulate", \
	Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5, \
	Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

# Inicia o minimapa e score
func init_map_score():
	# Adiciona o minimapa correspondente à fase especificada
	minimap = minimap_scene.instance()
	get_node("Control").add_child(minimap)
	# Deixa os itens invisíveis (pois antes da animação ainda estão na tela)
	minimap.visible = false
	score.visible = false
	# Espera um tempo antes de começar a animação
	yield(get_tree().create_timer(0.1), "timeout")
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
