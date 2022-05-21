extends CanvasLayer

export(float) var fade_in_time
export(float) var fade_out_time

# Animação de transição de tela
func fade_in(time = fade_in_time):
	$Tween.interpolate_property($ColorRect, "modulate", \
	Color(1, 1, 1, 1), Color(1, 1, 1, 0), time, \
	Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree().create_timer(time), "timeout")
	$ColorRect.visible = false

# Animação de transição de tela
func fade_out(time = fade_out_time):
	$ColorRect.visible = true
	$Tween.interpolate_property($ColorRect, "modulate", \
	Color(1, 1, 1, 0), Color(1, 1, 1, 1), time, \
	Tween.TRANS_LINEAR)
	$Tween.start()
