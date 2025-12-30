extends CharacterBody3D

@export var speed: float = 5.0
@export var run_speed: float = 9.0
@export var mouse_sensitivity: float = 0.002

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") as float

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head.rotation = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Поворот тела (Y)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Поворот головы (X)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, -1.4, 1.4)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var current_speed: float = run_speed if Input.is_action_pressed("run") else speed

	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("interact"): # Та же кнопка, что и для двери (E)
		var ray_length = 5.0
		var from = $Head/Camera3D.global_position
		var to = from - $Head/Camera3D.global_transform.basis.z * ray_length
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collision_mask = 1 # Проверяем только первый слой
		
		var result = space_state.intersect_ray(query)
		if result:
			var collider = result.collider
			if collider.has_method("interact"): # Если это интерактивный объект (диск)
				collider.interact()
		


func _on_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
