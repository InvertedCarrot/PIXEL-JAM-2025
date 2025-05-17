class_name Entity
extends CharacterBody2D

"""
Notes:
	1. AttackHitbox = Area where entity may attack another entity
	2. Hurtbox = Area where the entity may take damage
"""

# onready variables (specifically for node access)
@onready var zones = $DetectZones.get_children()
@onready var player_node = %Player.get_child(0)
@onready var timers_node = $Timers

# timers
@onready var atk_timer: Timer = timers_node.get_node("AttackCooldownTimer")
@onready var idle_pos_timer: Timer = timers_node.get_node("IdlePositionTimer")
@onready var strafe_timer: Timer = timers_node.get_node("StrafeTimer")
@onready var flee_timer: Timer = timers_node.get_node("FleeTimer")
@onready var immune_timer: Timer = timers_node.get_node("ImmunityCooldownTimer")

# abstract properties
var entity_name: String
var speed: float # travel speed through input
var max_momentum_scalar: float # maximum momentum attainable by the entity
var detect_zone_ranges: Array[float] # sizes of the detect zones, dertermining behaviour of enemies
var knockback_scalar = null

var is_player: bool = false # whether or not the entity is controllable through input
var is_dead: bool = false # contextually means two things: if the entity is dead (enemy), or if the entity is in spirit form (player)
var health: float
var damage: float
var direction: Vector2 # direction travelled by input
var raw_velocity: Vector2 # the "default" movement patterns of the entity
var momentum: Vector2 = Vector2.ZERO # for outside forces affecting the base movement (for random bursts of motion, like knockback, dashing)
var friction: float = 300 # rate at which momentum decays
var zone_number: int # the zone the player is currently in wrt the enemy

var entities_in_hurtbox: Array[Variant] = []

# for enemies:
var dist_to_player: float
var dir_to_player: Vector2
var curr_behaviour: Callable = idle_behaviour # chosen behaviour determined by zones

var entity_data: Dictionary


func set_properties() -> void:
	if (!entity_name):
		assert(false, "Define entity_name before calling set_properties()")
	# Set properties from globals
	entity_data = Globals.ENTITIES_DATA[entity_name]
	health = entity_data["health"]
	damage = entity_data["damage"]
	speed = entity_data["speed"]
	max_momentum_scalar = entity_data["max_momentum_scalar"]
	detect_zone_ranges = entity_data["detect_zone_ranges"]
	knockback_scalar = entity_data["knockback_scalar"]
	atk_timer.wait_time = entity_data["attack_cooldown"]
	idle_pos_timer.wait_time = entity_data["idle_position_cooldown"]
	strafe_timer.wait_time = entity_data["strafe_timer"] if entity_data.has("strafe_timer") else 1
	flee_timer.wait_time = entity_data["flee_timer"] if entity_data.has("flee_timer") else 1

func abstract_properties_checks() -> void:
	if (!entity_name):
		assert(false, "Error: entity_name must be defined")
	if (!health):
		assert(false, "Error: health must be defined")
	if (!damage):
		assert(false, "Error: damage must be defined")
	if (!speed):
		assert(false, "Error: speed must be defined")
	if (!max_momentum_scalar):
		assert(false, "Error: max_momentum_scalar must be defined")
	if (detect_zone_ranges.size() != 4):
		assert(false, "Error: detect_zone_ranges must be given sizes for zones [0, 1, 2, 3]")
	if (knockback_scalar == null):
		assert(false, "Error: knockback_scalar must be defined")

func set_layers() -> void: # invoked at _ready()
	var damage_hitbox = get_node("Hurtbox")

	if (is_player): # this is a PLAYER
		damage_hitbox.collision_layer = Globals.PLAYER_LAYER
		damage_hitbox.collision_mask = Globals.ENEMY_LAYER # only the player can be "attacked" through body contact (enemies are immune)
		collision_layer = Globals.PLAYER_LAYER
		collision_mask = Globals.WALL_LAYER

	else: # this is an ENEMY
		damage_hitbox.collision_layer = Globals.ENEMY_LAYER
		damage_hitbox.collision_mask = Globals.PLAYER_LAYER + Globals.ATTACK_LAYER # wrt the player, enemies can only get damaged by the melee attack
		collision_layer = Globals.ENEMY_LAYER
		collision_mask = Globals.WALL_LAYER


func _ready() -> void:
	set_properties()
	abstract_properties_checks()
	# set area2D sizes for visual clarity
	for i in range(zones.size()):
		var zone = zones[i]
		var collision_shape = zone.get_node("CollisionShape2D")
		collision_shape.shape.radius = detect_zone_ranges[i]
		
		# set all timers to oneshot
	for t: Timer in timers_node.get_children():
		t.one_shot = true
	set_layers()
	
	#DEBUG: set entities in random locations
	var x_negate = [1, -1].pick_random()
	var y_negate = [1, -1].pick_random()
	var spawn_range = [500.0, 700.0]
	position = Vector2(randf_range(spawn_range[0], spawn_range[1])*x_negate, randf_range(spawn_range[0]/2, spawn_range[1]/2)*y_negate)


func _process(delta: float) -> void:
	var prev_momentum: Vector2 = momentum # momentum value of the previous frame
	if (!is_player):
		dist_to_player = player_node.global_position.distance_to(global_position)
		dir_to_player = (player_node.global_position - global_position).normalized()
		zone_number = calculate_zone()
		
		# only switch states when there are no ongoing timers (i.e. a state is still "being processed")
		var state_switch_conds: bool = all_timers_stopped()
		# switch behaviour based on distance from player
		match zone_number:
			-1 when state_switch_conds: curr_behaviour = idle_behaviour
			0 when state_switch_conds: curr_behaviour = zone_0_behaviour
			1 when state_switch_conds: curr_behaviour = zone_1_behaviour
			2 when state_switch_conds: curr_behaviour = zone_2_behaviour
			3 when state_switch_conds: curr_behaviour = zone_3_behaviour
		# run behaviour decided upon by state
		curr_behaviour.call()
	
	if (is_player):
		# get directional input and convert to unit vector
		direction = Input.get_vector("left", "right", "up", "down")
		raw_velocity = direction * speed
		# Player attack
		if Input.is_action_just_pressed("attack") and atk_timer.is_stopped():
			attack()
			atk_timer.start()
	
	# damage calculations
	if entities_in_hurtbox.size() > 0:
		if immune_timer.is_stopped(): # if immune, don't take damage
			
			take_damage() # apply damage (we deal with death below)
			
			if is_player:
				Globals.player_health = health # assign current health to global file
			else: # is an enemy
				if (health <= 0):
					# Delete the node
					queue_free()
					# increase mFactor
					Globals.multiplier += 1
					# TODO: Scaling logic
			immune_timer.start()
	
	
	# reduce momentum towards 0 if not updated
	if prev_momentum == momentum:
		if momentum != Vector2.ZERO:
			momentum = momentum.normalized() * max(0, momentum.length() - friction*delta)
	# otherwise, make sure it never exceeds max_momentum_scalar
	else:
		momentum = momentum.normalized() * min(max_momentum_scalar, momentum.length())
	# idea behind velocity: first, we decide what "base movement" vector we want to move in via raw_velocity
	# then, we can choose to add a decaying movement vector to it (this is momentum)
	velocity = raw_velocity + momentum
	
	reflect_velocity(delta)

	# move_and_slide() # move with physics engine (already accounts for deltaTime)




# used by both the player and enemies

func attack():
	assert(false, "Error: attack() must be defined")

func take_damage():
	# calculate closest entity
	var closest_entity = null
	var closest_distance = INF
	var closest_entity_direction = Vector2.ZERO
	for e in entities_in_hurtbox:
		var position_diff = global_position - e.global_position
		var e_distance = position_diff.length()
		var e_direction = (position_diff).normalized()
		if e_distance < closest_distance:
			closest_entity = e
			closest_distance = e_distance
			closest_entity_direction = e_direction
	# apply some knockback based on the closest enemy
	var knockback_vector: Vector2 = closest_entity_direction * closest_entity.knockback_scalar
	momentum += knockback_vector
	# apply damage
	health -= closest_entity.damage
	print("%s took %d damage! (%d health left)" % [entity_name, closest_entity.damage, health])


func turn_into_player(): # change collision masks when possessing?
	is_player = true
	set_layers()
	Globals.max_player_health = health
	Globals.player_health = health

func turn_into_enemy(): # change collision masks when possessing?
	is_player = false
	set_layers()

func reflect_velocity(delta) -> void:
	# function for reflecting an enemy's movement
	var collision = move_and_collide(velocity * delta)
	if collision:
		momentum = momentum.bounce(collision.get_normal())
		if (is_player):
			direction = direction.bounce(collision.get_normal())
			move_and_slide()
		else:
			direction = direction.bounce(collision.get_normal())
			idle_pos_timer.stop()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	var root_node = area.get_parent() # could be entity OR attack_entity
	entities_in_hurtbox.append(root_node)

func _on_hurtbox_area_exited(area: Area2D) -> void:
	var root_node = area.get_parent() # could be entity OR attack_entity
	entities_in_hurtbox.erase(root_node)


func spawn_attack_entity(packed_scene: PackedScene, entity_direction: Vector2) -> Node:
	var attack_entity = packed_scene.instantiate()
	attack_entity.start_global_position = global_position
	attack_entity.start_direction = entity_direction
	attack_entity.from_player = is_player
	%AttackEntities.add_child(attack_entity)
	return attack_entity



############################## zone functionalities (enemies only) ##############################

func all_timers_stopped() -> bool: # used for switching between zones
	for t in timers_node.get_children():
		if !t.is_stopped():
			return false
	return true

func calculate_zone():
	var zone_num: int = -1
	for zone_dist in detect_zone_ranges:
		if dist_to_player >= zone_dist:
			break
		zone_num += 1
	return zone_num # return -1 if outside all zones

func idle_behaviour(): # abstract
	assert(false, "Error: idle_behaviour() must be defined")

func zone_0_behaviour(): # abstract
	assert(false, "Error: zone_0_behaviour() must be defined")

func zone_1_behaviour(): # abstract
	assert(false, "Error: zone_1_behaviour() must be defined")

func zone_2_behaviour(): # abstract
	assert(false, "Error: zone_2_behaviour() must be defined")

func zone_3_behaviour(): # abstract
	assert(false, "Error: zone_3_behaviour() must be defined")

# some helper functions to choose as behaviours
func default_roam(speed_scale: float = 1, angle_variation: float = 120) -> void:
	if idle_pos_timer.is_stopped():
		var angle_range = deg_to_rad(angle_variation)
		# choose new direction to travel
		var new_angle = direction.angle() + randf_range(-angle_range, angle_range)
		direction = Vector2(cos(new_angle), sin(new_angle))
		raw_velocity = direction * speed * speed_scale
		idle_pos_timer.start()

func default_pursuit(speed_scale: float = 1, strafe: bool = false, strafe_angle_deg: float = 0) -> void:
	var strafe_direction
	if strafe:
		# if strafing, decide on the angle to strafe at
		assert(strafe_angle_deg != 0, "Warning: if the entity is strafing, specify a strafing value")
		strafe_direction = [-1, 1].pick_random()
		if strafe_timer.is_stopped():
			var pursuit_angle = dir_to_player.angle() + strafe_direction * deg_to_rad(strafe_angle_deg)
			direction = Vector2(cos(pursuit_angle), sin(pursuit_angle))
			strafe_timer.start()
	# else, entity is not strafing, pursue normally (i.e. head-on)
	else:
		direction = dir_to_player
	raw_velocity = direction * speed * speed_scale

func default_stop(abrupt: bool = false) -> void:
	direction = dir_to_player # need this bc the AnimationTree uses direction to face the right way
	momentum = Vector2.ZERO if abrupt else velocity
	raw_velocity = Vector2.ZERO

func default_flee(speed_scale: float = 1) -> void:
	if flee_timer.is_stopped():
		direction = -dir_to_player # flip direction
		flee_timer.start()
	raw_velocity = direction * speed * speed_scale
