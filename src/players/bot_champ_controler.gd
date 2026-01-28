extends Champion

var timer_move : float = 0.0
var next_state_delay : float = 1.0 
var init_point : Vector3 = Vector3.ZERO
const delta_pos: int = 5

var state : int = 0 
# 0 = even
# 1 = scared
# 2 = aggresiv


func _ready():
	super._ready()
	type = "bot"
	stats = preload("res://data/sorakaData.tres")
	state = 0
	var new_position = get_next_position(state, delta_pos, init_point, Vector3(0,0,10))
	navigation_agent.set_target_position(new_position)
	pass


func get_next_position(flag: int, pdelta: int, pos_init: Vector3, opp_pos: Vector3) -> Vector3:
	var random_x
	var random_z
	if flag == 0:
		random_x = randf_range(pos_init.x - pdelta, pos_init.x + pdelta)
		random_z = randf_range(pos_init.z - pdelta, pos_init.z + pdelta)
	elif flag == 1:
		random_x = randf_range(pos_init.x - pdelta, pos_init.z - 2 * pdelta)
		random_z = randf_range(pos_init.z - pdelta, pos_init.z - 2 * pdelta)
	else:
		random_x = opp_pos.x
		random_z = opp_pos.z
	return Vector3(random_x, 0, random_z)

func print_state()->void:
	if state == 0:
		print("im passif")
	elif state == 1:
		print("im scared")
	else:
		print("im gonna get ya")
	pass


func _process(delta: float) -> void:
	physics_delta = delta
	timer_move += physics_delta
	if timer_move >= next_state_delay:
		var random = randi_range(0,3)
		while (random == state):
			random = randi_range(0,3)
		state = random
		var new_position = get_next_position(state, delta_pos, init_point, Vector3(0,0,10))
		navigation_agent.set_target_position(new_position)
		timer_move = 0.0
		next_state_delay = randf_range(1.0, 4.0)
		print_state()
	pass

func _on_navigation_agent_3d_target_reached():
	print("target_reached")
	var new_position = get_next_position(state, delta_pos, init_point, Vector3(0,0,10))
	navigation_agent.set_target_position(new_position)
	pass
