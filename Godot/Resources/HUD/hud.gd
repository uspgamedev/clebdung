extends CanvasLayer

onready var tween := get_node("Control/Tween")
onready var levelname := get_node("Control/LevelName")
onready var score := get_node("Control/ScoreRect/ScoreSprite")
onready var level := Globals.current_level
onready var level_id : int = level.get_level_id()
onready var power_up_manager : Node2D = level.get_power_up_manager()
var minimap_scene : PackedScene
var minimap : Control
var bottom_elements := []
export(String) var scene_name


func _ready():
	connect_slots()
	display_name()
	# Adiciona o minimapa correspondente à fase especificada
	minimap_scene = load("res://Resources/HUD/Minimaps/minimap_level" \
						 + str(level_id) + ".tscn")
	minimap = minimap_scene.instance()
	$Control.add_child(minimap)
	# Deixa os itens invisíveis (pois o HUD não está visível ainda)
	bottom_elements = [
		$Control/ScoreRect, 
		minimap, 
		$Control/Torch,
		$Control/PowerUpSlot3, 
		$Control/PowerUpSlot2, 
		$Control/PowerUpSlot1,
	]
	for elem in bottom_elements:
		elem.rect_position.y += 400

# Conecta os slots do HUD com os slots do Power Up Manager
func connect_slots():
	for i in range(1,4):
		var slot_number := str(i)
		var path := "Control/PowerUpSlot" + slot_number
		power_up_manager.connect_slot(get_node(path), slot_number)

# Mostra o nome da fase
func display_name():
	# Define o texto do  nó para o nome da fase correspondente
	levelname.bbcode_text = "[center][u]" + scene_name + "[/u][/center]"
	# Animação de aparecimento
	tween.interpolate_property(levelname, "modulate", Color(1, 1, 1, 0), \
	Color(1, 1, 1, 1), 1.5, Tween.TRANS_LINEAR)
	yield(get_tree().create_timer(0.3), "timeout")
	tween.start()

# Inicia os elementos da HUD
func init_HUD(torch_counter : int):
	
	$Control/Torch/TorchCounter.text = "x" + str(torch_counter)
	
	# Configura a animação do score e minimapa
	for i in range(0,2):
		var elem : Control = bottom_elements[i]
		tween.interpolate_property(elem, "rect_position:y", \
		elem.rect_position.y, elem.rect_position.y - 400, 1.4 + i*0.5, \
		tween.TRANS_BACK, tween.EASE_OUT)
	# Configura a animação dos power ups
	for i in range(2,6):
		var elem : Control = bottom_elements[i]
		tween.interpolate_property(elem, "rect_position:y", \
		elem.rect_position.y, elem.rect_position.y - 400, 1.4 + (i - 2)*0.25, \
		tween.TRANS_BACK, tween.EASE_OUT)
	# Inicia as animações
	tween.start()

# Atualiza o score em +1
func update_score():
	if score.update_score():
		level.unblock()
		

func update_torch(i : int):
	$Control/Torch.update_torch(i)

# Retira o nome da fase
func undisplay_name():
	# Animação de desaparecimento
	tween.interpolate_property(levelname, "modulate", Color(1, 1, 1, 1), \
	Color(1, 1, 1, 0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
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
