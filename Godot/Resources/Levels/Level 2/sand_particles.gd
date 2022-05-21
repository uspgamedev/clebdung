extends Particles2D

onready var pos = get_parent().get_node("Position2D")


func _ready():
	self.emitting = true
	position = pos.position


func _on_Timer_timeout():
	self.queue_free()
