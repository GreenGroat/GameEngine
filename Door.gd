extends StaticBody3D

@onready var initial_position = position

@export var open_offset: Vector3 = Vector3(0, 3, 0)
@export var open_speed: float = 2.0

var is_open: bool = false
var tween: Tween

func _ready():
    add_to_group("door")

func open():
    if not is_open:
        is_open = true
        tween = create_tween()
        tween.tween_property(self, "position", initial_position + open_offset, open_speed)

func close():
    if is_open:
        is_open = false
        tween = create_tween()
        tween.tween_property(self, "position", initial_position, open_speed)

func _on_receiver_activated():
    open()

func _on_receiver_deactivated():
    close()
