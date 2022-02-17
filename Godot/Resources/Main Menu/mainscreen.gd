extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tweenP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	tweenP = get_node("Ghost/Tween").is_active()
	if tweenP:
		get_node("Player/Timer").start(1.5)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
