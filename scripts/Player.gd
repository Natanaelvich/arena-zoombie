extends CharacterBody2D

# Variáveis do jogador
@export var speed = 200.0  # Velocidade de movimento
@export var health = 100   # Vida do jogador
@export var max_health = 100

# Variáveis para o tiro
@export var bullet_speed = 600.0
@export var fire_rate = 0.2  # Tempo entre tiros em segundos
@export var bullet_scene: PackedScene  # Referência à cena do projétil
var can_fire = true
var fire_timer = 0.0

# Referência ao nó de animação (será configurado na cena)
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var shoot_sound = $ShootSound
@onready var hit_sound = $HitSound

# Sinal emitido quando o jogador é atingido
signal player_hit(new_health)
# Sinal emitido quando o jogador morre
signal player_died

func _ready():
	# Inicialização do jogador
	# Adiciona o jogador ao grupo "player" para facilitar a referência
	add_to_group("player")

func _process(delta):
	# Rotaciona o jogador para olhar para o mouse
	look_at(get_global_mouse_position())
	
	# Gerencia o cooldown do tiro
	if !can_fire:
		fire_timer += delta
		if fire_timer >= fire_rate:
			can_fire = true
			fire_timer = 0.0
	
	# Verifica se o jogador está atirando
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()

func _physics_process(delta):
	# Obtém a direção do movimento
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	# Normaliza a direção para evitar movimento mais rápido na diagonal
	if direction.length() > 0:
		direction = direction.normalized()
		# Aqui você pode ativar a animação de movimento
		if animation_player and animation_player.has_animation("run"):
			animation_player.play("run")
	else:
		# Aqui você pode ativar a animação de idle
		if animation_player and animation_player.has_animation("idle"):
			animation_player.play("idle")
	
	# Define a velocidade
	velocity = direction * speed
	
	# Move o jogador
	move_and_slide()

# Função para atirar
func shoot():
	if not bullet_scene:
		print("Erro: Cena do projétil não configurada!")
		return
	
	can_fire = false
	
	# Cria uma instância do projétil
	var bullet = bullet_scene.instantiate()
	
	# Adiciona o projétil à cena principal
	get_tree().current_scene.add_child(bullet)
	
	# Configura a posição e direção do projétil
	# Posiciona o projétil um pouco à frente do jogador para evitar colisão imediata
	var spawn_offset = Vector2(20, 0).rotated(rotation)
	bullet.global_position = global_position + spawn_offset
	
	# Define a direção do projétil para onde o jogador está olhando
	var direction = Vector2.RIGHT.rotated(rotation)
	bullet.direction = direction
	bullet.rotation = direction.angle()
	
	# Toca o som de tiro
	if shoot_sound:
		shoot_sound.play()
	
	# Aqui você pode ativar a animação de tiro
	if animation_player and animation_player.has_animation("shoot"):
		animation_player.play("shoot")

# Função chamada quando o jogador é atingido
func take_damage(amount):
	health -= amount
	emit_signal("player_hit", health)
	
	# Toca o som de dano
	if hit_sound:
		hit_sound.play()
	
	if health <= 0:
		die()
	else:
		# Aqui você pode ativar a animação de dano
		if animation_player and animation_player.has_animation("hit"):
			animation_player.play("hit")

# Função chamada quando o jogador morre
func die():
	emit_signal("player_died")
	
	# Aqui você pode ativar a animação de morte
	if animation_player and animation_player.has_animation("death"):
		animation_player.play("death")
	
	# Desativa o jogador
	set_process(false)
	set_physics_process(false)
	
	# Você pode adicionar um timer para remover o jogador após a animação
	# await get_tree().create_timer(1.0).timeout
	# queue_free() 