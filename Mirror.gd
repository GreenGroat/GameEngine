extends StaticBody3D

@onready var mesh = $MeshInstance3D

func _ready():
	add_to_group("mirror")
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.9, 0.9, 0.9)
	mat.metallic = 1.0
	mat.roughness = 0.1
	mesh.material_override = mat
