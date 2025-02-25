extends Node

# Este script configura os mapeamentos de entrada para o jogo

func _ready():
	# Limpa os mapeamentos existentes para evitar duplicações
	clear_existing_mappings()
	
	# Configura os controles de movimento
	setup_movement_controls()
	
	# Configura os controles de ação
	setup_action_controls()

func clear_existing_mappings():
	# Lista de ações que vamos configurar
	var actions = ["move_up", "move_down", "move_left", "move_right", "shoot", "pause"]
	
	# Remove os mapeamentos existentes
	for action in actions:
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
		else:
			InputMap.add_action(action)

func setup_movement_controls():
	# Teclas WASD
	add_key_mapping("move_up", KEY_W)
	add_key_mapping("move_down", KEY_S)
	add_key_mapping("move_left", KEY_A)
	add_key_mapping("move_right", KEY_D)
	
	# Teclas de seta
	add_key_mapping("move_up", KEY_UP)
	add_key_mapping("move_down", KEY_DOWN)
	add_key_mapping("move_left", KEY_LEFT)
	add_key_mapping("move_right", KEY_RIGHT)

func setup_action_controls():
	# Botão de tiro (botão esquerdo do mouse)
	var mouse_event = InputEventMouseButton.new()
	mouse_event.button_index = MOUSE_BUTTON_LEFT
	mouse_event.pressed = true
	InputMap.action_add_event("shoot", mouse_event)
	
	# Tecla de pausa
	add_key_mapping("pause", KEY_ESCAPE)
	add_key_mapping("pause", KEY_P)

func add_key_mapping(action_name, key_code):
	var event = InputEventKey.new()
	event.keycode = key_code
	event.pressed = true
	InputMap.action_add_event(action_name, event) 