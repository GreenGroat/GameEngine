extends StaticBody3D

@export var locked: bool = true
@export var open_distance: float = 1.5
@export var open_direction: Vector3 = Vector3(0, 0, -1)
@export var auto_open: bool = true  # Автоматически открываться при подходе

var is_open: bool = false
var player_in_range: bool = false

func _ready():
	# Устанавливаем цвет двери
	update_door_color()
	
	# Подключаем сигналы от DetectionArea
	if has_node("DetectionArea"):
		$DetectionArea.body_entered.connect(_on_body_entered)
		$DetectionArea.body_exited.connect(_on_body_exited)
	else:
		print("Предупреждение: у двери нет DetectionArea!")

func _process(_delta):
	# Если включено автооткрытие и игрок в зоне
	if auto_open and player_in_range and not is_open and not locked:
		open()

func _on_body_entered(body):
	# Проверяем, что вошел игрок
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_range = true
		print("Игрок подошел к двери")

func _on_body_exited(body):
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_range = false
		print("Игрок отошел от двери")

func update_door_color():
	if has_node("MeshInstance3D"):
		var mesh = $MeshInstance3D
		var material = mesh.get_surface_override_material(0)
		
		if not material:
			# Создаем новый материал
			material = StandardMaterial3D.new()
			mesh.material_override = material
		
		if locked:
			material.albedo_color = Color(0.8, 0.2, 0.2)  # Красный
		else:
			material.albedo_color = Color(0.2, 0.8, 0.2)  # Зеленый

func unlock():
	locked = false
	update_door_color()
	print("Дверь разблокирована")
	return true

func open():
	if locked:
		print("Дверь заперта!")
		return false
	
	if is_open:
		print("Дверь уже открыта")
		return false
	
	is_open = true
	
	# Анимация открытия
	var tween = create_tween()
	var target_position = position + (open_direction.normalized() * open_distance)
	tween.tween_property(self, "position", target_position, 1.0)
	
	# Отключаем коллизию
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true
	
	print("Дверь открывается...")
	return true

# Для теста: сразу разблокировать и открыть
func unlock_and_open():
	unlock()
	open()


func _on_puzzle_manager_puzzle_solved() -> void:
	pass # Replace with function body.
