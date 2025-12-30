extends Area3D

@export var message_title: String = "ПОДСКАЗКА"
@export var message_text: String = "Ты нашел подсказку!"
@export var show_once: bool = true
@export var show_on_enter: bool = true  # Показывать при входе в зону
@export var require_interact: bool = false  # Требовать нажатия E
@export var interact_key: String = "interact"

var already_triggered = false
var player_in_area = false

func _ready():
	# Скрываем визуализацию в игре
	if has_node("MeshInstance3D"):
		$MeshInstance3D.visible = Engine.is_editor_hint()
	
	# Подключаем сигналы
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	# Если требуется взаимодействие и игрок в зоне
	if player_in_area and require_interact and Input.is_action_just_pressed(interact_key):
		if !show_once or (show_once and !already_triggered):
			show_trigger_message()
			already_triggered = true

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_area = true
		
		# Если показываем при входе и не требуется взаимодействие
		if show_on_enter and !require_interact:
			if !show_once or (show_once and !already_triggered):
				show_trigger_message()
				already_triggered = true

func _on_body_exited(body):
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_area = false

func show_trigger_message():
	# Используем GameManager для показа сообщения
	GameManager.show_global_message(message_title, message_text)
	
	# Можно добавить звук или другие эффекты
	print("Триггер активирован: ", name)
