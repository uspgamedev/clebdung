extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var anim_direc = "Right"
var lastpos = "Left"
onready var TweenNode = get_node("Tween")
var attpos = 1
var postogo
var anim_s = "Right"
var init = false
var c = true
var rng = RandomNumberGenerator.new()



onready var pos1 = get_parent().get_node("pos1")
onready var pos2 = get_parent().get_node("pos2")
onready var pos3 = get_parent().get_node("pos3")
onready var pos4 = get_parent().get_node("pos4")

onready var positionsR = [pos2, pos4]

onready var positionsL = [pos1, pos3]

# Called when the node enters the scene tree for the first time.
func _ready():
	TweenNode.interpolate_property(self, "position", get_position(), pos1.position, 1.0,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	TweenNode.start()

func _physics_process(delta): 
	set_direction()

func set_direction():
		#Determinar direção
	var animation
	
	
	
	if Input.is_action_pressed("ui_left") and c:
		anim_direc = "Left"
		anim_s = "Left"
		init = true
	elif Input.is_action_pressed("ui_right") and c:
		anim_direc = "Right"
		anim_s = "Right"
		init = true
	
	animation = anim_s + "_" + "Walk"
	
	
	
	if lastpos != anim_direc and init:
		change_pos()
	elif c:
		get_node("AnimationPlayer").play(animation)
	lastpos = anim_direc
func change_pos():
	get_node("Timer").start(1)
	c = false
	if attpos == 1:
		postogo = positionsR[rng.randi_range(0,1)]
		TweenNode.interpolate_property(self,"position", get_position(), postogo.position, 1.0,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		TweenNode.start()
		get_node("AnimationPlayer").play("Left_Vanish")
		attpos = 2
	elif attpos == 2:
		postogo = positionsL[rng.randi_range(0,1)]
		TweenNode.interpolate_property(self,"position", get_position(), postogo.position, 1.0,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		TweenNode.start()
		get_node("AnimationPlayer").play("Right_Vanish")
		attpos = 1
	


func _on_Timer_timeout():
	c = true
