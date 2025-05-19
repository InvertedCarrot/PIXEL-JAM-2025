extends Entity

var fire_trail_scene: PackedScene = preload("res://scenes/attack_entities/fire_trail/fire_trail.tscn")
var potion_scene: PackedScene = preload("res://scenes/attack_entities/potion/potion.tscn")
var scratch_scene: PackedScene = preload("res://scenes/attack_entities/scratch/scratch.tscn")
var scythe_scene: PackedScene = preload("res://scenes/attack_entities/scythe/scythe.tscn")
var spore_scene: PackedScene = preload("res://scenes/attack_entities/spore/spore.tscn")


func _ready() -> void:
	entity_name = "cat"
	super()

func _process(delta: float) -> void:
	super(delta)

func idle_behaviour() -> void:
	idle_behaviour_aggressive()

func zone_0_behaviour() -> void:
	zone_0_behaviour_aggressive()

func zone_1_behaviour() -> void:
	zone_1_behaviour_aggressive()

func zone_2_behaviour() -> void:
	zone_2_behaviour_aggressive()

func zone_3_behaviour() -> void:
	zone_3_behaviour_aggressive()



func idle_behaviour_aggressive() -> void:
	default_pursuit(1)

func zone_0_behaviour_aggressive() -> void:
	if atk_timer.is_stopped() && zone_number == 0:
		attack_with_potion()
		atk_timer.start()
	default_pursuit(1, true, 30)

func zone_1_behaviour_aggressive() -> void:
	if atk_timer.is_stopped() && zone_number == 1:
		attack_with_scythe()
		atk_timer.start()
	default_pursuit(1, true, 45)

func zone_2_behaviour_aggressive() -> void:
	if atk_timer.is_stopped() && zone_number == 2:
		attack()
		atk_timer.start()
	default_pursuit(1)

func zone_3_behaviour_aggressive() -> void:
	if atk_timer.is_stopped() && zone_number == 3:
		attack()
		atk_timer.start()
	default_pursuit(1)







func attack() -> void:
	var scratch = spawn_attack_entity(scratch_scene, direction)
	scratch.global_position += 100 * direction

func attack_with_potion():
	var potion_amount = 4
	var deg_between_potions: float = 15
	var angle_offset_deg = -(potion_amount - 1) * deg_between_potions/2
	for i in range(potion_amount):
		var attack_angle
		if is_player:
			attack_angle = direction.angle() + deg_to_rad(angle_offset_deg)
		else:
			attack_angle = dir_to_player.angle() + deg_to_rad(angle_offset_deg)
		spawn_attack_entity(potion_scene, Vector2(cos(attack_angle), sin(attack_angle)))
		angle_offset_deg += deg_between_potions

func attack_with_scythe():
	spawn_attack_entity(scythe_scene, direction)



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

func default_stop(abrupt: bool = false, look_at: bool = true) -> void:
	if look_at: direction = dir_to_player # need this bc the AnimationTree uses direction to face the right way
	momentum = Vector2.ZERO if abrupt else velocity
	raw_velocity = Vector2.ZERO

func default_flee(speed_scale: float = 1) -> void:
	if flee_timer.is_stopped():
		direction = -dir_to_player # flip direction
		flee_timer.start()
	raw_velocity = direction * speed * speed_scale
