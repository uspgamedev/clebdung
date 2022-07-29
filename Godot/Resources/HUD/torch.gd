extends Control

func update_torch(i : int):
	$TorchCounter.text = \
	"x" + str(int($TorchCounter.text.trim_prefix("x")) + i)
