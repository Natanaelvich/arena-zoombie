extends CharacterBody2D

# Variáveis do zumbi
@export var speed = 100.0  # Velocidade de movimento
@export var health = 30    # Vida do zumbi
@export var damage = 10    # Dano que o zumbi causa ao jogador
@export var score_value = 10  # Pontos ganhos ao matar este zumbi

# Referência ao jogador (será configurado quando o zumbi for criado)
var player = null

# Referência ao nó de animação (será configurado na cena)
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hit_sound = $HitSound
@onready var death_sound = $DeathSound
@onready var blood_particles = $BloodParticles

# Sinal emitido quando o zumbi morre
signal zombie_died(score)

func _ready():
	# Adiciona o zumbi ao grupo "zombies" para facilitar a referência
	add_to_group("zombies")
	
	# Tenta encontrar o jogador na cena
	player = get_node_or_null("/root/Main/Player")
	if not player:
		# Tenta encontrar o jogador pelo grupo
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]

func _physics_process(delta):
	if player and is_instance_valid(player):
		# Calcula a direção para o jogador
		var direction = (player.global_position - global_position).normalized()
		
		# Define a velocidade
		velocity = direction * speed
		
		# Rotaciona o zumbi para olhar para o jogador
		look_at(player.global_position)
		
		# Ativa a animação de andar
		if animation_player and animation_player.has_animation("walk"):
			animation_player.play("walk")
		
		# Move o zumbi
		move_and_slide()
		
		# Verifica colisão com o jogador
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider == player:
				attack_player()

# Função chamada quando o zumbi ataca o jogador
func attack_player():
	if player.has_method("take_damage"):
		player.take_damage(damage)
		
		# Ativa a animação de ataque
		if animation_player and animation_player.has_animation("attack"):
			animation_player.play("attack")

# Função chamada quando o zumbi é atingido
func take_damage(amount):
	health -= amount
	
	# Toca o som de dano
	if hit_sound:
		hit_sound.play()
	
	# Ativa as partículas de sangue
	if blood_particles:
		blood_particles.restart()
		blood_particles.emitting = true
	
	if health <= 0:
		die()
	else:
		# Ativa a animação de dano
		if animation_player and animation_player.has_animation("hit"):
			animation_player.play("hit")

# Função chamada quando o zumbi morre
func die():
	# Emite o sinal de morte com o valor de pontuação
	emit_signal("zombie_died", score_value)
	
	# Toca o som de morte
	if death_sound:
		death_sound.play()
	
	# Ativa a animação de morte
	if animation_player and animation_player.has_animation("death"):
		animation_player.play("death")
	
	# Remove do grupo de zumbis
	remove_from_group("zombies")
	
	# Desativa o zumbi
	set_physics_process(false)
	
	# Desativa a colisão
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Remove o zumbi após um curto período (para permitir que a animação termine)
	await get_tree().create_timer(1.5).timeout
	queue_free() 