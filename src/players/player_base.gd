extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var target = Vector3.ZERO

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var camera_3D: Camera3D = $"../Camera3D"

func _ready():
	print("Hell0")
	

func _physics_process(delta):
	var next_path_point = $NavigationAgent3D.get_next_path_position()
	var new_velocity = (next_path_point - global_position).normalized() * SPEED
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	move_and_slide()

func _process(delta: float) -> void:
	#$camera3D.global_position = $camera_marker.global_position
	#$camera3D.look_at(Vector3.ZERO,Vector3.UP)
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("move_click"):
			move_to_click(event)
			
	if event.is_action_pressed("ui_accept"):
		var random_pos := Vector3.ZERO
		random_pos.x = randf_range(-2.5, 2.5)
		random_pos.z = randf_range(-2.5, 2.5)
		print("random_position: ", random_pos)
		navigation_agent.set_target_position(random_pos)

func move_to_click(event: InputEvent):
	var from = camera_3D.project_ray_origin(event.position)
	var to = camera_3D.project_local_ray_normal(event.position)
	var Cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
	print("from: ",from)
	print("to: ", to)
	print("Cursor: ",Cursor_pos)
	#$NavigationAgent3D.target_position = Cursor_pos
	pass
