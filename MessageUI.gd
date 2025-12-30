extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label

func _ready():
	panel.visible = false

func show_message(title: String, text: String, duration: float = 3.0):
	label.text = title + "\n" + text
	panel.visible = true
	
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		panel.visible = false

func hide_message():
	panel.visible = false
