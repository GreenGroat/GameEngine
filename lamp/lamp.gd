# Lamp.gd
# Godot 4.5.1
class_name Lamp
extends Node3D

signal lamp_interacted(lamp_id: int)

@export var lamp_id: int = 0
@export var mesh_path: NodePath = "Mesh"
@export var light_path: NodePath = "Light3D"
@export var area_path: NodePath = "Area3D"

# typed refs
var mesh: MeshInstance3D
var light_node: Light3D
var area: Area3D
var player_inside: bool = false
var lit: bool = false

func _ready() -> void:
	# get children by paths
	mesh = get_node_or_null(mesh_path) as MeshInstance3D
	light_node = get_node_or_null(light_path) as Light3D
	area = get_node_or_null(area_path) as Area3D

	if area:
		area.connect("body_entered", Callable(self, "_on_body_entered"))
		area.connect("body_exited", Callable(self, "_on_body_exited"))
	# ensure initial state
	set_lit(false)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = true
		# optional: show hint, e.g. call HUD
		# print("Player in lamp area:", lamp_id)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = false

func _process(_delta: float) -> void:
	# if player stands in area and presses UI key - emit event
	if player_inside and Input.is_action_just_pressed("ui_accept"):
		emit_signal("lamp_interacted", lamp_id)

func set_lit(value: bool) -> void:
	lit = value
	if light_node:
		light_node.visible = value
	if mesh:
		# убедимся, что материал есть
		if mesh.get_active_material(0):
			var mat := mesh.get_active_material(0)
			if mat is StandardMaterial3D:
				if value:
					mat.albedo_color = Color(1.2, 1.05, 0.6) # светло-жёлтый
				else:
					mat.albedo_color = Color(1,1,1) # стандартный
