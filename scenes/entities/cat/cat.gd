extends Entity

var fire_trail_scene: PackedScene = preload("res://scenes/attack_entities/fire_trail/fire_trail.tscn")
var potion_scene: PackedScene = preload("res://scenes/attack_entities/potion/potion.tscn")
var scratch_scene: PackedScene = preload("res://scenes/attack_entities/scratch/scratch.tscn")
var scythe_scene: PackedScene = preload("res://scenes/attack_entities/scythe/scythe.tscn")
var spore_scene: PackedScene = preload("res://scenes/attack_entities/spore/spore.tscn")

@onready var ss_timer = $StateSwitchTimer
var curr_state: int
var state_switch_cooldown

enum states {
	AGGRESSIVE = 0,
	DEFENSIVE = 1,
	HYBRID = 2
}

func set_properties() -> void:
	super()
	state_switch_cooldown = entity_data["state_switch_cooldown"]

func abstract_properties_checks() -> void:
	super()
	if (!state_switch_cooldown):
		assert(false, "Error: state_switch_cooldown must be defined")

func _ready() -> void:
	entity_name = "cat"
	super()
	curr_state = 0
	ss_timer.wait_time = state_switch_cooldown # states switch every (this amonut) seconds
	
	# TODO: fix later, only activate timer when cutscene is done
	ss_timer.start()

func _process(delta: float) -> void:
	super(delta)

func idle_behaviour() -> void:
	if curr_state == states.AGGRESSIVE:
		idle_behaviour_aggressive()
	elif curr_state == states.DEFENSIVE:
		idle_behaviour_defensive()
	else:
		idle_behaviour_hybrid()

func zone_0_behaviour() -> void:
	if curr_state == states.AGGRESSIVE:
		zone_0_behaviour_aggressive()
	elif curr_state == states.DEFENSIVE:
		zone_0_behaviour_defensive()
	else:
		zone_0_behaviour_hybrid()

func zone_1_behaviour() -> void:
	if curr_state == states.AGGRESSIVE:
		zone_1_behaviour_aggressive()
	elif curr_state == states.DEFENSIVE:
		zone_1_behaviour_defensive()
	else:
		zone_1_behaviour_hybrid()

func zone_2_behaviour() -> void:
	if curr_state == states.AGGRESSIVE:
		zone_2_behaviour_aggressive()
	elif curr_state == states.DEFENSIVE:
		zone_2_behaviour_defensive()
	else:
		zone_2_behaviour_hybrid()

func zone_3_behaviour() -> void:
	if curr_state == states.AGGRESSIVE:
		zone_3_behaviour_aggressive()
	elif curr_state == states.DEFENSIVE:
		zone_3_behaviour_defensive()
	else:
		zone_3_behaviour_hybrid()


# aggressive behaviours
func idle_behaviour_aggressive() -> void:
	default_pursuit(1)

func zone_0_behaviour_aggressive() -> void:
	default_pursuit(1, true, 30)
	if atk_timer.is_stopped() && zone_number == 0:
		act_with_potion(4)
		atk_timer.start()

func zone_1_behaviour_aggressive() -> void:
	default_pursuit(1, true, 45)
	if atk_timer.is_stopped() && zone_number == 1:
		act_with_scythe()
		atk_timer.start()

func zone_2_behaviour_aggressive() -> void:
	default_pursuit(1)
	if atk_timer.is_stopped() && zone_number == 2:
		attack()
		atk_timer.start()

func zone_3_behaviour_aggressive() -> void:
	zone_2_behaviour_aggressive()


# defensive behaviours
func idle_behaviour_defensive() -> void:
	default_roam(0.2)

func zone_0_behaviour_defensive() -> void:
	default_flee(0.5)

func zone_1_behaviour_defensive() -> void:
	default_pursuit(0.7, true, 90)
	if flee_timer.is_stopped() && zone_number == 1:
		act_with_spore(6)
		flee_timer.start()

func zone_2_behaviour_defensive() -> void:
	default_pursuit(0.7, true, 120)
	if flee_timer.is_stopped() && zone_number == 2:
		act_with_scythe()
		flee_timer.start()

func zone_3_behaviour_defensive() -> void:
	if flee_timer.is_stopped() && zone_number == 3:
		momentum = direction * max_momentum_scalar # increase speed when dashing at player
		act_with_fire(3)
		flee_timer.start()
	raw_velocity = Vector2.ZERO


# defensive hybrid
func idle_behaviour_hybrid() -> void:
	default_roam(1)

func zone_0_behaviour_hybrid() -> void:
	if atk_timer.is_stopped() && zone_number == 0:
		act_with_fire(1)
		act_with_potion(1)
		atk_timer.start()
	default_pursuit()

func zone_1_behaviour_hybrid() -> void:
	default_pursuit(1, true, 70)
	if atk_timer.is_stopped() && zone_number == 1:
		act_with_fire(1)
		atk_timer.start()

func zone_2_behaviour_hybrid() -> void:
	default_flee()
	if flee_timer.is_stopped() && zone_number == 2:
		act_with_spore(4)
		flee_timer.start()

func zone_3_behaviour_hybrid() -> void:
	default_pursuit(1, true, 10)
	if atk_timer.is_stopped() && zone_number == 3:
		attack()
		atk_timer.start()



# what to do when attacking

func attack() -> void:
	var scratch = spawn_attack_entity(scratch_scene, direction)
	scratch.global_position += 100 * direction

func act_with_potion(potion_amount):
	var deg_between_potions: float = 15
	var angle_offset_deg = -(potion_amount - 1) * deg_between_potions/2
	for i in range(potion_amount):
		var attack_angle = dir_to_player.angle() + deg_to_rad(angle_offset_deg)
		spawn_attack_entity(potion_scene, Vector2(cos(attack_angle), sin(attack_angle)))
		angle_offset_deg += deg_between_potions

func act_with_scythe():
	spawn_attack_entity(scythe_scene, direction)

func act_with_spore(spore_amount) -> void:
	var spore_range_deg: float = 240
	var angle_between_spores_deg: float = spore_range_deg/(spore_amount - 1)
	var spore_angle_offset_deg: float = -spore_range_deg/2
	for i in range(spore_amount):
		var spore_angle = dir_to_player.angle() + deg_to_rad(spore_angle_offset_deg)
		spore_angle += deg_to_rad(randf_range(-angle_between_spores_deg/3, angle_between_spores_deg/3))
		spawn_attack_entity(spore_scene, Vector2(cos(spore_angle), sin(spore_angle)))
		spore_angle_offset_deg += angle_between_spores_deg

func act_with_fire(fire_trail_amount):
	for i in range(fire_trail_amount):
		var fire_trail_entity: Node = spawn_attack_entity(fire_trail_scene, direction)
		fire_trail_entity.velocity = momentum * (i+0.8)/fire_trail_amount
		fire_trail_entity.decceleration = friction


# when state timer is done, move to next state
func _on_state_switch_timer_timeout() -> void:
	curr_state = (curr_state + 1) % states.size()
	ss_timer.start()
