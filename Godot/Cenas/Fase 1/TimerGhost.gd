extends Label

func _process(delta):
	set_text(str(int($Timer.get_time_left())))
