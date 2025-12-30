extends StaticBody3D

# Сигнал, который диск испускает при каждом повороте
signal disk_rotated(disk_id, current_position)

# Уникальный ID диска (задаётся в редакторе для каждого)
@export var disk_id: int = 1
# Текущее положение (0, 1, 2, 3 - всего 4 варианта)
var current_position: int = 0
# Правильное положение для этого диска (задаётся в редакторе)
@export var correct_position: int = 0

# Функция взаимодействия. Её будет вызывать игрок.
func interact():
	# Вращаем на 90 градусов
	rotate_y(deg_to_rad(90))
	# Обновляем позицию по модулю 4 (0,1,2,3,0,1...)
	current_position = (current_position + 1) % 4
	# Испускаем сигнал с данными: ID диска и его новая позиция
	emit_signal("disk_rotated", disk_id, current_position)
	print("Диск ", disk_id, " повёрнут. Позиция: ", current_position)
