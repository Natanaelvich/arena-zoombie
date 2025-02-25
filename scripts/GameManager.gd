extends Node

# Variáveis do jogo
var score = 0
var wave = 1
var zombies_killed = 0
var zombies_per_wave = 5
var game_over = false

# Sinal emitido quando a pontuação muda
signal score_changed(new_score)
# Sinal emitido quando a onda muda
signal wave_changed(new_wave)
# Sinal emitido quando o jogo termina
signal game_ended

func _ready():
	# Inicialização do jogo
	pass

# Incrementa a pontuação e emite o sinal
func add_score(points):
	score += points
	emit_signal("score_changed", score)
	
	# Verifica se matou todos os zumbis da onda atual
	zombies_killed += 1
	if zombies_killed >= zombies_per_wave:
		next_wave()

# Avança para a próxima onda
func next_wave():
	wave += 1
	zombies_killed = 0
	zombies_per_wave += 2  # Aumenta a dificuldade
	emit_signal("wave_changed", wave)

# Finaliza o jogo
func end_game():
	game_over = true
	emit_signal("game_ended")

# Reinicia o jogo
func restart_game():
	score = 0
	wave = 1
	zombies_killed = 0
	zombies_per_wave = 5
	game_over = false
	emit_signal("score_changed", score)
	emit_signal("wave_changed", wave) 