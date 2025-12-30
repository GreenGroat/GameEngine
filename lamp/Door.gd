# Door.gd
extends Node3D

@export var open_anim: NodePath # если есть анимация
var opened: bool = false

func open() -> void:
	if opened:
		return
	opened = true
	print("Door: open called")

	# скрываем визуалку (MeshInstance3D)
	for child in get_children():
		if child is MeshInstance3D:
			child.visible = false
		# отключаем коллизию
		if child is CollisionShape3D:
			child.disabled = true

	# если есть AnimationPlayer, проигрываем анимацию
	if open_anim:
		var ap := get_node_or_null(open_anim)
		if ap and ap is AnimationPlayer:
			ap.play("open")
