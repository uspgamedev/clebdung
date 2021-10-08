extends Label

func _process(_delta):
	set_text(str(int($Timer.get_time_left())))
