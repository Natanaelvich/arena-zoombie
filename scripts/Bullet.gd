extends Area2D

# Variáveis do projétil
@export var speed = 600.0  # Velocidade do projétil
@export var damage = 10    # Dano causado pelo projétil
@export var lifetime = 2.0  # Tempo de vida do projétil em segundos

# Direção do movimento
var direction = Vector2.RIGHT  # Direção padrão (será definida quando o projétil for criado)

# Referência ao nó de animação (será configurado na cena)
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var lifetime_timer = $LifetimeTimer

func _ready():
	# Configura o timer de vida útil
	lifetime_timer.wait_time = lifetime
	lifetime_timer.connect("timeout", Callable(self, "_on_lifetime_timer_timeout"))
	lifetime_timer.start()
	
	# Rotaciona o sprite para apontar na direção do movimento
	rotation = direction.angle()

func _physics_process(delta):
	# Move o projétil na direção especificada
	position += direction * speed * delta

# Função chamada quando o projétil colide com algo
func _on_body_entered(body):
	# Verifica se o corpo é um zumbi
	if body.is_in_group("zombies") and body.has_method("take_damage"):
		# Causa dano ao zumbi
		body.take_damage(damage)
		
		# Desativa o projétil
		disable()

# Função chamada quando o tempo de vida do projétil acaba
func _on_lifetime_timer_timeout():
	# Remove o projétil
	queue_free()

# Função para desativar o projétil (após acertar algo)
func disable():
	# Desativa a colisão
	collision_shape.set_deferred("disabled", true)
	
	# Torna o sprite invisível
	sprite.visible = false
	
	# Remove o projétil após um curto período
	await get_tree().create_timer(0.1).timeout
	queue_free() 