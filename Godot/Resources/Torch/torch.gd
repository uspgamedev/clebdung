extends Sprite

signal collected_torch

func _ready():
	add_to_group("Torchs")

func _on_CollectionArea_body_entered(_body):
	emit_signal("collected_torch")
	queue_free()
