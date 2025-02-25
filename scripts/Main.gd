extends Node2D

# Referências a cenas
@export var zombie_scene: PackedScene
@export var player_scene: PackedScene

# Referências a nós
@onready var arena = $Arena
@onready var zombie_container = $Arena/ZombieContainer
@onready var spawn_points = $Arena/SpawnPoints
@onready var player = $Player
@onready var ui = $UI
@onready var spawn_timer = $SpawnTimer

# Variáveis do jogo
var game_running = false
var spawn_time = 3.0  # Tempo inicial entre spawns de zumbis
var min_spawn_time = 0.5  # Tempo mínimo entre spawns
var difficulty_increase_rate = 0.1  # Quanto o tempo de spawn diminui a cada onda

# Referência ao gerenciador de jogo
var game_manager

func _ready():
	# Inicializa o gerenciador de jogo
	game_manager = get_node("/root/GameManager")
	
	# Conecta sinais
	if game_manager:
		game_manager.connect("wave_changed", Callable(self, "_on_wave_changed"))
		game_manager.connect("game_ended", Callable(self, "_on_game_ended"))
	
	# Configura o timer de spawn
	spawn_timer.wait_time = spawn_time
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	
	# Conecta sinais do jogador
	if player:
		player.connect("player_died", Callable(self, "_on_player_died"))
	
	# Inicia o jogo
	start_game()

func start_game():
	game_running = true
	spawn_timer.start()

func _on_wave_changed(new_wave):
	# Aumenta a dificuldade reduzindo o tempo entre spawns
	spawn_time = max(min_spawn_time, spawn_time - difficulty_increase_rate)
	spawn_timer.wait_time = spawn_time

func _on_game_ended():
	game_running = false
	spawn_timer.stop()

func _on_player_died():
	if game_manager:
		game_manager.end_game()

func _on_spawn_timer_timeout():
	if game_running:
		spawn_zombie()

func spawn_zombie():
	if zombie_scene and spawn_points and zombie_container:
		# Obtém um ponto de spawn aleatório
		var spawn_markers = spawn_points.get_children()
		if spawn_markers.size() > 0:
			var random_index = randi() % spawn_markers.size()
			var spawn_position = spawn_markers[random_index].global_position
			
			# Instancia um novo zumbi
			var zombie_instance = zombie_scene.instantiate()
			zombie_container.add_child(zombie_instance)
			
			# Configura a posição do zumbi
			zombie_instance.global_position = spawn_position
			
			# Conecta o sinal de morte do zumbi
			zombie_instance.connect("zombie_died", Callable(self, "_on_zombie_died"))

func _on_zombie_died(score):
	if game_manager:
		game_manager.add_score(score) 