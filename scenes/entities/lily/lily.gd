extends Entity

var spore_scene: PackedScene = preload("res://scenes/attack_entities/spore/spore.tscn")

var spore_amount: float
var original_atk_time
var angered = false

func set_properties() -> void:
	super()
	spore_amount = entity_data["spore_amount"]

func abstract_properties_checks() -> void:
	super()
	if (!spore_amount):
		assert(false, "Error: spore_amount must be defined")

func _ready() -> void:
	entity_name = "lily"
	super()
	original_atk_time = atk_timer.wait_time

func _process(delta: float) -> void:
	super(delta)
	if angered:
		atk_timer.wait_time = original_atk_time
	else:
		atk_timer.wait_time = 2*original_atk_time # slowed attack speed if not damaged

# for reapers, we need 3 zones ("pursuit", "stalk" and "attack")
# idle = -1, pursuit = 0, stalk = 1, attack = 2

func idle_behaviour() -> void:
	if !angered:
		default_roam(0.2)
	else:
		default_roam(0.5)

func zone_0_behaviour() -> void:
	if !angered:
		if atk_timer.is_stopped():
			attack()
			atk_timer.start()
		default_roam(0.5)
	else:
		default_pursuit(1, true, 30)

func zone_1_behaviour() -> void:
	if !angered:
		if atk_timer.is_stopped():
			attack()
			atk_timer.start()
		default_roam(0.5)
	else:
		if atk_timer.is_stopped() && zone_number == 1: # only continue attacking if player is close by
			attack()
			atk_timer.start()
		default_pursuit(1, true, 70)

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	spore_amount = floor(spore_amount)
	var spore_range_deg: float = 240
	var angle_between_spores_deg: float = spore_range_deg/(spore_amount - 1)
	var spore_angle_offset_deg: float = -spore_range_deg/2
	for i in range(spore_amount):
		var spore_angle
		if is_player || !angered:
			spore_angle = direction.angle() + deg_to_rad(spore_angle_offset_deg)
		else:
			spore_angle = dir_to_player.angle() + deg_to_rad(spore_angle_offset_deg)
		spore_angle += deg_to_rad(randf_range(-angle_between_spores_deg/3, angle_between_spores_deg/3))
		spawn_attack_entity(spore_scene, Vector2(cos(spore_angle), sin(spore_angle)))
		spore_angle_offset_deg += angle_between_spores_deg

func take_damage():
	angered = true
