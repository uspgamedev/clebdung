extends Sprite

onready var player = get_parent().get_node("YSort/Player")
onready var player_sprite = player.get_node("PlayerSprite")
onready var p_u_slot1 = player.get_node("PowerUpSlot1")
onready var p_u_slot2 = player.get_node("PowerUpSlot2")
onready var p_u_slot3 = player.get_node("PowerUpSlot3")
onready var power_up1 = get_node("PowerUp")
onready var power_up2 = get_node("PowerUp2")
onready var power_up3 = get_node("PowerUp3")
var p_u1_sprite = null
var p_u2_sprite = null
var p_u3_sprite = null


func _ready():
	# Inicia completamente visível
	get_material().set_shader_param("mask", 1)
	p_u_slot1.connect("used_slot", self, "updateSlot1")
	p_u_slot1.connect("setted_slot", self, "updateSlot1")
	p_u_slot2.connect("used_slot", self, "updateSlot2")
	p_u_slot2.connect("setted_slot", self, "updateSlot2")
	p_u_slot3.connect("used_slot", self, "updateSlot3")
	p_u_slot3.connect("setted_slot", self, "updateSlot3")

func _process(_delta):
	# Atualiza a posição e o frame do sprite
	position = player_sprite.global_position
	frame = player_sprite.frame
	if p_u1_sprite != null:
		power_up1.frame = p_u1_sprite.frame
	if p_u2_sprite != null:
		power_up2.frame = p_u2_sprite.frame
	if p_u3_sprite != null:
		power_up3.frame = p_u3_sprite.frame

func updateSlot1(_a = null):
	if p_u1_sprite == null:
		p_u1_sprite = p_u_slot1.get_children()[0].get_node("Sprite")
		power_up1.texture = p_u1_sprite.texture
	else:
		p_u1_sprite = null
		power_up1.texture = null
	
func updateSlot2(_a = null):
	if p_u2_sprite == null:
		p_u2_sprite = p_u_slot2.get_children()[0].get_node("Sprite")
		power_up2.texture = p_u2_sprite.texture
	else:
		p_u2_sprite = null
		power_up2.texture = null

func updateSlot3(_a = null):
	if p_u3_sprite == null:
		p_u3_sprite = p_u_slot3.get_children()[0].get_node("Sprite")
		power_up3.texture = p_u3_sprite.texture
	else:
		p_u3_sprite = null
		power_up3.texture = null
