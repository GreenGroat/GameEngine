# LampPuzzle.gd
extends Node3D
signal puzzle_completed

@export var lamp_nodes: Array[NodePath] = []    # укажи пути к 5 лампам в инспекторе
@export var sequence: Array[int] = [0, 1, 2, 3, 4] # последовательность lamp_id
@export var reset_on_wrong: bool = true        # сброс при неверном ходе
@export var allow_reuse_after_lit: bool = false # можно перезаписывать зажжённые лампы
@export var door_path: NodePath                # путь к двери, которая должна открыться

# В рантайме
var lamps: Array[Lamp] = []
var cursor: int = 0  # индекс в sequence (какую лампу ждём)
var door: Node = null

func _ready() -> void:
	# собираем лампы по указанным путям
	lamps.clear()
	for p in lamp_nodes:
		var node: Node = get_node_or_null(p)
		if node == null:
			push_error("LampPuzzle: node not found at path %s" % str(p))
			continue
		var lamp := node as Lamp
		if lamp == null:
			push_error("LampPuzzle: node at %s is not a Lamp" % str(p))
			continue
		# подписываемся на сигнал
		lamp.connect("lamp_interacted", Callable(self, "_on_lamp_interacted"))
		lamps.append(lamp)
		# гарантируем, что все лампы погашены в начале
		lamp.set_lit(false)

	# получаем дверь
	if door_path != null:
		door = get_node_or_null(door_path)
		if door == null:
			push_error("LampPuzzle: door not found at path %s" % str(door_path))

	# sanity
	cursor = 0

func _on_lamp_interacted(lamp_id: int) -> void:
	# вызывается при взаимодействии с любой лампой
	if cursor >= sequence.size():
		return
	var expected_id := int(sequence[cursor])
	print(lamp_id, expected_id)
	if lamp_id == expected_id:
		# правильный выбор
		var lamp := _find_lamp_by_id(lamp_id)
		if lamp != null:
			lamp.set_lit(true)
		cursor += 1
		# проверка завершения
		if cursor >= sequence.size():
			print("LampPuzzle: completed")
			emit_signal("puzzle_completed")
			_open_door()
	else:
		# неправильный выбор
		print("LampPuzzle: wrong lamp. expected %s got %s" % [str(sequence[cursor]), str(lamp_id)])
		if reset_on_wrong:
			_reset_all()

func _find_lamp_by_id(lid: int) -> Lamp:
	for l in lamps:
		if l.lamp_id == lid:
			return l
	return null

func _reset_all() -> void:
	for l in lamps:
		l.set_lit(false)
	cursor = 0

func _open_door() -> void:
	if door:
		# проверяем, есть ли метод open()
		if door.has_method("open"):
			door.call("open")
			print("LampPuzzle: door opened")
		else:
			push_warning("LampPuzzle: door exists but has no open() method")
