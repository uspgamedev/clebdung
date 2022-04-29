extends CanvasLayer

onready var tween = get_node("Control/Tween")
onready var score = get_node("Control/ScoreRect")
onready var levelname = get_node("Control").get_node("LevelName")
onready var power_up1 = get_node("Control/PowerUpSlot1")
onready var power_up2 = get_node("Control/PowerUpSlot2")
onready var power_up3 = get_node("Control/PowerUpSlot3")
export(PackedScene) var minimap_scene
export(String) var scene_name
var minimap
var bottom_elements = []

func _ready():
	display_name()
	# Adiciona o minimapa correspondente à fase especificada
	minimap = minimap_scene.instance()
	get_node("Control").add_child(minimap)
	# Deixa os itens invisíveis (pois o HUD não está visível ainda)
	bottom_elements = [score, minimap, power_up3, power_up2, power_up1]
	for elem in bottom_elements:
		elem.rect_position.y += 400

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

# Inicia os elementos da HUD
func init_HUD():
	# Configura a animação do score e minimapa
	for i in range(0,2):
		var elem = bottom_elements[i]
		tween.interpolate_property(elem, "rect_position:y", \
		elem.rect_position.y, elem.rect_position.y - 400, 1.4 + i*0.5, \
		tween.TRANS_BACK, tween.EASE_OUT)
	# Configura a animação dos power ups
	for i in range(2,5):
		var elem = bottom_elements[i]
		tween.interpolate_property(elem, "rect_position:y", \
		elem.rect_position.y, elem.rect_position.y - 400, 1.4 + (i - 2)*0.25, \
		tween.TRANS_BACK, tween.EASE_OUT)
	# Inicia as animações
	tween.start()
	
# Retira o HUD da tela
func finish():
	# Configura a animação do score e minimapa
	for i in range(0,2):
		var elem = bottom_elements[i]
		tween.interpolate_property(elem, "rect_position:y", \
		elem.rect_position.y, elem.rect_position.y + 400, 0.5 + i*0.25, \
		tween.TRANS_BACK, tween.EASE_IN)
	# Configura a animação dos power ups
	for i in range(2,5):
		var elem = bottom_elements[i]
		tween.interpolate_property(elem, "rect_position:y", \
		elem.rect_position.y, elem.rect_position.y + 400, 0.5 + (i - 2)*0.1, \
		tween.TRANS_BACK, tween.EASE_IN)
	# Inicia as animações
	tween.start()
