extends CanvasLayer

# Referências aos nós da UI
@onready var score_label = $ScoreContainer/ScoreLabel
@onready var wave_label = $WaveContainer/WaveLabel
@onready var health_bar = $HealthContainer/HealthBar
@onready var game_over_panel = $GameOverPanel
@onready var final_score_label = $GameOverPanel/VBoxContainer/FinalScoreLabel
@onready var restart_button = $GameOverPanel/VBoxContainer/RestartButton

# Referência ao gerenciador de jogo
var game_manager

func _ready():
	# Inicializa o gerenciador de jogo
	game_manager = get_node("/root/GameManager")
	
	# Conecta sinais
	if game_manager:
		game_manager.connect("score_changed", Callable(self, "_on_score_changed"))
		game_manager.connect("wave_changed", Callable(self, "_on_wave_changed"))
		game_manager.connect("game_ended", Callable(self, "_on_game_ended"))
	
	# Conecta o sinal do botão de reiniciar
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	
	# Inicializa a UI
	update_score(0)
	update_wave(1)
	game_over_panel.visible = false
	
	# Tenta conectar o sinal do jogador
	var player = get_node_or_null("/root/Main/Player")
	if player:
		player.connect("player_hit", Callable(self, "_on_player_hit"))
		update_health(player.health, player.max_health)

func update_score(new_score):
	if score_label:
		score_label.text = "Score: " + str(new_score)

func update_wave(new_wave):
	if wave_label:
		wave_label.text = "Wave: " + str(new_wave)

func update_health(current_health, max_health):
	if health_bar:
		health_bar.value = (float(current_health) / max_health) * 100

func show_game_over(final_score):
	if game_over_panel and final_score_label:
		final_score_label.text = "Final Score: " + str(final_score)
		game_over_panel.visible = true

func _on_score_changed(new_score):
	update_score(new_score)

func _on_wave_changed(new_wave):
	update_wave(new_wave)

func _on_player_hit(new_health):
	var player = get_node_or_null("/root/Main/Player")
	if player:
		update_health(new_health, player.max_health)

func _on_game_ended():
	if game_manager:
		show_game_over(game_manager.score)

func _on_restart_button_pressed():
	# Reinicia o jogo
	if game_manager:
		game_manager.restart_game()
	
	# Esconde o painel de game over
	game_over_panel.visible = false
	
	# Recarrega a cena principal
	get_tree().reload_current_scene() 