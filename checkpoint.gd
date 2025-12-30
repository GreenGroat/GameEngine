extends Area3D

@export var message: String = "Нажмите E"

var player_inside := false

@onready var ui_label: Label = get_tree().get_first_node_in_group("ui_label")

func _on_body_entered(body):
	if body is CharacterBody3D:
		player_inside = true
		ui_label.text = message
		ui_label.visible = true

func _on_body_exited(body):
	if body is CharacterBody3D:
		player_inside = false
		ui_label.visible = false
