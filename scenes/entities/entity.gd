class_name Entity
extends CharacterBody2D

@onready var zones = $DetectZones.get_children()
@onready var player_node = %Player.get_child(0)
@onready var timers = $Timers
@export var detect_zone_ranges: Array[float]

var max_speed: float
var speed: float
var direction: Vector2

var dist_to_player: float
var dir_to_player: Vector2

var is_player: bool = false
var start_position = Vector2.ZERO

var curr_behaviour: Callable = idle_behaviour

func _ready() -> void:
	position = start_position
	if (!speed):
		assert(false, "Error: speed must be defined")
	if (!max_speed):
		assert(false, "Error: max_speed must be defined")
	if (detect_zone_ranges.size() != 4):
		assert(false, "Error: detect_zone_ranges must be given sizes for zones [0, 1, 2, 3]")
		
	# set area2D sizes for visual clarity
	for i in range(zones.size()):
		var zone = zones[i]
		var collision_shape = zone.get_node("CollisionShape2D")
		collision_shape.shape.radius = detect_zone_ranges[i]


func _process(delta: float) -> void:
	if (!is_player):
		dist_to_player = player_node.global_position.distance_to(global_position)
		dir_to_player = (player_node.global_position - global_position).normalized()
		
		
		var sst: Timer = timers.get_node("StateSwitchTimer")
		var zone_number: int = calculate_zone()
		
		var state_reset = func(stateTimer: Timer):
			stateTimer.wait_time = randf_range(0.6, 1.2)
			stateTimer.start()
		
		# switch behaviour based on distance from player
		match zone_number:
			-1 when sst.is_stopped():
				curr_behaviour = idle_behaviour # DON't state_reset() here
			0 when sst.is_stopped():
				curr_behaviour = zone_0_behaviour
				state_reset.call(sst)
			1 when sst.is_stopped():
				curr_behaviour = zone_1_behaviour
				state_reset.call(sst)
			2 when sst.is_stopped():
				curr_behaviour = zone_2_behaviour
				state_reset.call(sst)
			3 when sst.is_stopped():
				curr_behaviour = zone_3_behaviour
				state_reset.call(sst)
		# run behaviour decided upon by state
		curr_behaviour.call(delta)
	
	if (is_player):
		# get directional input and convert to unit vector
		direction = Input.get_vector("left","right","up","down")
		velocity = direction * speed
	
	move_and_slide() # already accounts for deltaTime

func idle_behaviour(delta: float):
	assert(false, "Error: idle_behaviour() must be defined")

func zone_0_behaviour(delta: float):
	assert(false, "Error: zone_0_behaviour() must be defined")

func zone_1_behaviour(delta: float):
	assert(false, "Error: zone_0_behaviour() must be defined")

func zone_2_behaviour(delta: float):
	assert(false, "Error: zone_0_behaviour() must be defined")

func zone_3_behaviour(delta: float):
	assert(false, "Error: zone_0_behaviour() must be defined")

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

func turn_into_enemy(): # same?
	pass
