extends CanvasLayer

export(float) var fade_in_time
export(float) var fade_out_time

# Animação de transição de tela
func fade_in():
	$Tween.interpolate_property($ColorRect, "modulate", \
	Color(1, 1, 1, 1), Color(1, 1, 1, 0), fade_in_time, \
	Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree().create_timer(fade_in_time), "timeout")
	$ColorRect.visible = false

# Animação de transição de tela
func fade_out():
	$ColorRect.visible = true
	$Tween.interpolate_property($ColorRect, "modulate", \
	Color(1, 1, 1, 0), Color(1, 1, 1, 1), fade_out_time, \
	Tween.TRANS_LINEAR)
	$Tween.start()
