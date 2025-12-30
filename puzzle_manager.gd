extends Node

# ГЛАВНЫЙ СИГНАЛ - его ловит дверь
signal puzzle_solved

# Массив для хранения ВСЕХ дисков
@onready var disks: Array = []

func _ready():
	print("=== ИНИЦИАЛИЗАЦИЯ МЕНЕДЖЕРА ПАЗЛА ===")
	
	# Вариант 1: Если диски лежат в папке Disks (лучший способ)
	var disks_container = get_parent().get_node("Disks")
	
	# Вариант 2: Если диски просто рядом с менеджером (запасной способ)
	if not disks_container:
		print("Папка 'Disks' не найдена, ищу диски рядом...")
		disks_container = get_parent()
	
	# Собираем ВСЕ диски
	for child in disks_container.get_children():
		if child is StaticBody3D and child.has_method("interact"):
			disks.append(child)
			print("Найден диск: ID=", child.disk_id, 
				  " Правильная позиция=", child.correct_position,
				  " Текущая позиция=", child.current_position)
	
	if disks.size() == 0:
		print("ОШИБКА: Не найден ни один диск!")
		return
	
	print("Всего дисков: ", disks.size())
	
	# Подключаем сигналы от КАЖДОГО диска
	for disk in disks:
		if disk.has_signal("disk_rotated"):
			disk.disk_rotated.connect(_on_disk_rotated)
			print("Сигнал подключен к диску ID=", disk.disk_id)
		else:
			print("ОШИБКА: У диска ID=", disk.disk_id, " нет сигнала disk_rotated!")
	
	print("Менеджер готов к работе!")
	print("=================================")

func _on_disk_rotated(disk_id: int, current_position: int):
	print("--- Диск ", disk_id, " повернут в позицию ", current_position, " ---")
	_check_solution()

func _check_solution():
	print("\n[ПРОВЕРКА РЕШЕНИЯ]")
	var all_correct = true
	
	for disk in disks:
		print("Диск ", disk.disk_id, 
			  ": текущая=", disk.current_position, 
			  ", нужная=", disk.correct_position)
		
		if disk.current_position != disk.correct_position:
			all_correct = false
			print("  -> НЕ СОВПАДАЕТ!")
		else:
			print("  -> OK")
	
	if all_correct:
		print("\n✅✅✅ ВСЕ ДИСКИ В ПРАВИЛЬНЫХ ПОЗИЦИЯХ! ✅✅✅")
		print("ИСПУСКАЮ СИГНАЛ: puzzle_solved")
		emit_signal("puzzle_solved")
		return true
	else:
		print("Пазл еще не решен")
		return false

# Вспомогательная функция для поиска диска по ID (на всякий случай)
func _find_disk_by_id(disk_id: int):
	for disk in disks:
		if disk.disk_id == disk_id:
			return disk
	return null
