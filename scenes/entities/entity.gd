class_name Entity
extends CharacterBody2D

@onready var zones = $DetectZones.get_children()
@onready var player_node = %Player.get_child(0)
@onready var timers = $Timers


# abstract properties
var enemy_name: String # the enemy name for enemies
var max_speed: float # maximum speed attainable by the entity
var speed: float # travel speed through input
var detect_zone_ranges: Array[float] # sizes of the detect zones, dertermining behaviour of enemies


var is_player: bool = false # whether or not the entity is controllable through input
var direction: Vector2 # direction travelled by input
var start_position = Vector2.ZERO
var momentum: Vector2 # for outside forces affecting the base movement (for random bursts of motion, like knockback, dashing)
var friction: float = 300 # rate at which movement decays if over max_speed
var zone_number: int # the zone the player is currently in wrt the enemy

# for enemies:
var dist_to_player: float
var dir_to_player: Vector2
var curr_behaviour: Callable = idle_behaviour # chosen behaviour determined by zones

func set_enemy_properties(enemy_name: String)->void:
	var enemy_data = Globals.ENEMIES_DATA[enemy_name]
	speed = enemy_data["speed"]
	max_speed = Globals.ENEMIES_DATA[enemy_name]["max_speed"]
	detect_zone_ranges = enemy_data["detect_zone_ranges"]
	start_position = enemy_data["start_position"]
	$Timers/AttackCooldownTimer.wait_time = enemy_data["attack_cooldown"]
	$Timers/StateSwitchTimer.wait_time = enemy_data["state_switch_cooldown"]
	$Timers/IdlePositionTimer.wait_time = enemy_data["idle_position_cooldown"]

func abstract_properties_checks() -> void:
	if (!speed):
		assert(false, "Error: speed must be defined")
	if (!max_speed):
		assert(false, "Error: max_speed must be defined")
	if (detect_zone_ranges.size() != 4):
		assert(false, "Error: detect_zone_ranges must be given sizes for zones [0, 1, 2, 3]")


func _ready() -> void:
	abstract_properties_checks()
	
	position = start_position
	# set area2D sizes for visual clarity
	for i in range(zones.size()):
		var zone = zones[i]
		var collision_shape = zone.get_node("CollisionShape2D")
		collision_shape.shape.radius = detect_zone_ranges[i]


func _process(delta: float) -> void:
	#momentum = Vector2.ZERO # this is for outside forces affecting the base movement
	
	if (!is_player):
		dist_to_player = player_node.global_position.distance_to(global_position)
		dir_to_player = (player_node.global_position - global_position).normalized()
		
		var act: Timer = timers.get_node("AttackCooldownTimer")
		var sst: Timer = timers.get_node("StateSwitchTimer")
		zone_number = calculate_zone()
		
		var state_reset = func(stateTimer: Timer):
			stateTimer.wait_time = randf_range(0.6, 1.2)
			stateTimer.start()
		
		# only switch states when states can be changed and any ongoing attacks are done
		var state_switch_conds = (sst.is_stopped() && act.is_stopped())
		
		# switch behaviour based on distance from player
		match zone_number:
			-1 when state_switch_conds:
				curr_behaviour = idle_behaviour # DON't state_reset() here
			0 when state_switch_conds:
				curr_behaviour = zone_0_behaviour
				state_reset.call(sst)
			1 when state_switch_conds:
				curr_behaviour = zone_1_behaviour
				state_reset.call(sst)
			2 when state_switch_conds:
				curr_behaviour = zone_2_behaviour
				state_reset.call(sst)
			3 when state_switch_conds:
				curr_behaviour = zone_3_behaviour
				state_reset.call(sst)
		# run behaviour decided upon by state
		curr_behaviour.call()
	
	if (is_player):
		# get directional input and convert to unit vector
		direction = Input.get_vector("left","right","up","down")
		velocity = direction * speed
	
	# reduce momentum towards 0
	if momentum.length() > 0:
		momentum = momentum.normalized() * max(0, momentum.length() - friction*delta)
	# idea behind velocity: first, we decide what "base movement" vector we want to move in
	# then, we can choose to add a decaying movement vector to it (this is momentum)
	velocity += momentum
	
	reflect_velocity() #TODO: later
	
	move_and_slide() # move with physics engine (already accounts for deltaTime)






func idle_behaviour():
	assert(false, "Error: idle_behaviour() must be defined")

func zone_0_behaviour():
	assert(false, "Error: zone_0_behaviour() must be defined")

func zone_1_behaviour():
	assert(false, "Error: zone_1_behaviour() must be defined")

func zone_2_behaviour():
	assert(false, "Error: zone_2_behaviour() must be defined")

func zone_3_behaviour():
	assert(false, "Error: zone_3_behaviour() must be defined")

# used by both the player and enemies
func attack():
	assert(false, "Error: attack() must be defined")

func hit():
	# call when the entity gets hit (take damage, die, e.t.c)
	pass

func calculate_zone():
	var zone_num: int = -1
	for zone_dist in detect_zone_ranges:
		if dist_to_player >= zone_dist:
			break
		zone_num += 1
	return zone_num # return -1 if outside all zones


func turn_into_player(): # change collision masks when possessing?
	pass

func turn_into_enemy(): # change collision masks when possessing?
	pass

func reflect_velocity() -> void:
	# function for reflecting an enemy's movement
	# this is so that enemies bounce off walls and don't continually run into them
	# do this once we add a TileMapLayer and a prototype room
	pass
