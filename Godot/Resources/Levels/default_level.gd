extends Node
class_name LevelRoot

export(String, FILE, "*.tscn") var next_scene_path
export(Vector2) var init_direction
export(float) var init_time
export(Vector2) var finish_direction
export(float) var finish_time
var level_id : int
var init_level := false
var first_time := true
var torchs_counter : int
var save_dict : Dictionary
var ghosts_group : Array
var crystals_group : Array
var torchs_group : Array
var power_ups_group: Array
onready var player := get_node("YSort/Player")
onready var hud := get_node("HUD")
onready var fade := get_node("Fade")
onready var guide := get_node("Guide")
onready var level_music := get_node("LevelMusic")
onready var win_animplayer := get_node("YSort/Exit/AnimationPlayer")
onready var power_up_manager := get_node("YSort/Player/PowerUpManager")



func _enter_tree():
	level_id = int(get_name().trim_prefix("Level"))
	Globals.current_level = self


func _ready():
	player.connect("die", self, "die")
	load_basic_info()
	init()


# Retorna uma referência ao jogador
func get_player():
	return $YSort/Player

# Retorna uma referência ao Astar
func get_astar():
	return $"A*"

# Retorna uma referência ao Power Up Manager
func get_power_up_manager():
	return $YSort/Player/PowerUpManager

# Retorna a posição da saída
func get_exit_position():
	return $YSort/Exit/ExitPosition2D.global_position

# Retorna o id numérico do level
func get_level_id():
	return int(get_name().trim_suffix("Level"))


func load_basic_info():
	save_dict = SaveManager.load_save()
	torchs_counter = save_dict["torchs_counter"]
	
	var equiped_power_ups : Array = save_dict["equiped_power_ups"]
	power_up_manager.set_slots(equiped_power_ups)


func respawn_itens():
	var saved_torchs_positions : Array = save_dict["saved_torchs"]
	for i in range(len(torchs_group)):
		if i < len(saved_torchs_positions):
			torchs_group[i].global_position = saved_torchs_positions[i]
		else:
			torchs_group[i].queue_free()
	
	var saved_power_ups : Array = save_dict["saved_power_ups"]
	for power_up in power_ups_group:
		var exists = false
		for i in range(len(saved_power_ups)):
			var saved_power_up = saved_power_ups[i]
			if saved_power_up[1] == power_up.id:
				power_up.global_position = saved_power_up[0]
				saved_power_ups.remove(i)
				exists = true
				break
		if not exists:
			power_up.queue_free()


# Inicia a fase
func init():
	# Toca a transição de tela
	fade.fade_in()
	# Bloqueia temporariamente input do jogador e simula caminhar
	# em uma direção determinada
	player.target_position = player.global_position + 32*init_direction
	player.direction = init_direction
	
	# Conecta os sinais dos cristais com o HUD
	crystals_group = get_tree().get_nodes_in_group("Crystals")
	for crystal in crystals_group:
		crystal.connect("collected_crystal", hud, "update_score")
		
	torchs_group = get_tree().get_nodes_in_group("Torchs")
	for torch in torchs_group:
		torch.connect("collected_torch", self, "collect_torch")
	
	power_ups_group = get_tree().get_nodes_in_group("PowerUps")
	
	var last_level = SaveManager.get_last_level()
	if last_level == level_id:
		respawn_itens()
	else:
		save_current_game()
	
	yield(get_tree().create_timer(init_time), "timeout")
	# Bloqueia fantasmas
	ghosts_group = get_tree().get_nodes_in_group("Ghosts")
	for ghost in ghosts_group:
		ghost.set_physics_process(false)
	player.input_enabled = true
	
	


func detect_move():
	# Assim que o primeiro movimento for feito, desbloqueia fantasmas
	# e retira o nome da fase da tela
	if (
		init_level == false 
		and player.input_enabled 
		and (Input.is_action_pressed("ui_up")
			 or Input.is_action_pressed("ui_down") 
			 or Input.is_action_pressed("ui_left") 
			 or Input.is_action_pressed("ui_right")
		)
	):
		init_level = true
		for ghost in ghosts_group:
			ghost.set_physics_process(true)
		hud.undisplay_name()
		hud.init_HUD(torchs_counter)


func _process(_delta):
	# Código padrão
	detect_move()


func collect_torch():
	torchs_counter += 1
	hud.update_torch(1)


func use_torch():
	if torchs_counter == 0:
		pass ## GAME OVER
	torchs_counter -= 1
	hud.update_torch(-1)


# Desbloqueia a saída após coleta dos cristais
func unblock():
	# Ativa o modo caos
	get_tree().call_group("Ghosts","f_chaos")
	# Atualiza o estado do bloqueio da saída
	win_animplayer.play("Unblocked")
	# Ativa o guia
	guide.enable()

# Trava o jogador em direção à saída
func lock_player():
	# Desativa input do jogador e simula caminhar à uma direção determinada
	player.input_enabled = false
	player.direction = finish_direction
	# Desativa o guia
	guide.disable()
	# Toca a música final
	level_music.finish_music()

# Ganha a fase (animação final)
func win():
	# Código padrão
	lock_player()
	# Espera o jogador avançar um pouco no caminho da saída
	yield(get_tree().create_timer(finish_time), "timeout")
	# Código padrão
	finish_level()

# Finaliza o level e troca de cena
func finish_level():
	save_current_game()
	# Retira o HUD
	hud.finish()
	# Toca a transição de tela
	fade.fade_out()
	# Desativa o modo chaos dos fantasmas
	get_tree().call_group("Ghosts","f_chaos")
	# Aguarda e troca de cena
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene(next_scene_path)

func die():
	if torchs_counter == 0:
		pass
	save_current_game()
	get_tree().reload_current_scene()


func save_current_game():
	var equiped_power_ups : Array = power_up_manager.get_equiped()
	
	var saved_torchs := []
	torchs_group = get_tree().get_nodes_in_group("Torchs")
	for torch in torchs_group:
		saved_torchs.append(torch.global_position)
		
	var saved_power_ups := []
	power_ups_group = get_tree().get_nodes_in_group("PowerUps")
	for power_up in power_ups_group:
		saved_power_ups.append([power_up.global_position, power_up.id])
		
	SaveManager.save_game(level_id, torchs_counter, equiped_power_ups, \
	saved_torchs, saved_power_ups)
