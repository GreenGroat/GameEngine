extends Node

# Синглтон - доступен из любой точки игры
static var instance: GameManager

# UI элементы
var message_panel: Panel
var message_label: Label
var message_timer: Timer

func _ready():
	# Сохраняем ссылку на себя как синглтон
	instance = self
	
	# Создаем UI для сообщений
	create_message_ui()
	
	print("GameManager загружен!")

func create_message_ui():
	# Создаем CanvasLayer для UI
	var canvas = CanvasLayer.new()
	canvas.name = "MessageCanvas"
	canvas.layer = 10  # Высокий слой, чтобы было поверх всего
	add_child(canvas)
	
	# Панель для сообщений
	message_panel = Panel.new()
	message_panel.name = "MessagePanel"
	
	# Настройки панели
	message_panel.custom_minimum_size = Vector2(600, 120)
	message_panel.position = Vector2(200, 400)  # Центр экрана (примерно)
	message_panel.visible = false
	
	# Стиль панели (опционально)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 0.9)
	style.border_color = Color(0.5, 0.3, 0.1, 1)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	message_panel.add_theme_stylebox_override("panel", style)
	
	canvas.add_child(message_panel)
	
	# Label для текста
	message_label = Label.new()
	message_label.name = "MessageLabel"
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message_label.size = Vector2(580, 100)
	message_label.position = Vector2(10, 10)
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# Стиль текста
	message_label.add_theme_font_size_override("font_size", 20)
	message_label.add_theme_color_override("font_color", Color.WHITE)
	
	message_panel.add_child(message_label)
	
	# Таймер для автоскрытия сообщений
	message_timer = Timer.new()
	message_timer.name = "MessageTimer"
	message_timer.one_shot = true
	message_timer.timeout.connect(_on_message_timer_timeout)
	add_child(message_timer)

# Показ сообщения
func show_message(title: String, text: String, duration: float = 3.0):
	if message_panel and message_label:
		message_label.text = "" + title + "\n" + text
		message_panel.visible = true
		
		# Запускаем таймер автоскрытия
		if duration > 0:
			message_timer.start(duration)

# Скрытие сообщения
func hide_message():
	if message_panel:
		message_panel.visible = false

# Обработка таймера
func _on_message_timer_timeout():
	hide_message()

# Статический метод для удобного вызова
static func show_global_message(title: String, text: String, duration: float = 3.0):
	if instance:
		instance.show_message(title, text, duration)

# Статический метод для скрытия
static func hide_global_message():
	if instance:
		instance.hide_message()
