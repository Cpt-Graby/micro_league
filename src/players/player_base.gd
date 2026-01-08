extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var target = Vector3.ZERO

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup() -> void:
	await get_tree().physics_frame
	pass

func set_movement_target(movement_target: Vector3)-> void:
	navigation_agent.set_target_position(movement_target)
	pass


func _physics_process(delta):
	var next_path_point = $NavigationAgent3D.get_next_path_position()
	var new_velocity = (next_path_point - global_position).normalized() * SPEED
	velocity.x = new_velocity.x
	velocity.y = new_velocity.y
	move_and_slide()


func _process(delta: float) -> void:
	$camera3D.global_position = $camera_marker.global_position
	$camera3D.look_at(Vector3.ZERO,Vector3.UP)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("move_click"):
			move_to_click(event)
			
func move_to_click(event: InputEvent):
	var from = $camera3D.project_ray_origin(event.position)
	var to = from + $camera3D.project_local_ray_normal(event.position) * 1000
	var Cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
	print(Cursor_pos)
	$NavigationAgent3D.target_position = Cursor_pos
	pass
