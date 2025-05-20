extends Entity

var potion_scene: PackedScene = preload("res://scenes/attack_entities/potion/potion.tscn")

var potion_amount: float


func set_properties() -> void:
	super()
	potion_amount = entity_data["potion_amount"][0]

func abstract_properties_checks() -> void:
	super()
	check_array_property_exists("potion_amount")

func scale_entity_stats():
	super()
	potion_amount = scale_property("potion_amount")

func _ready() -> void:
	entity_name = "bird"
	super()

func _process(delta: float) -> void:
	super(delta)
	if Globals.check_dialogue_state("first_fight", 1, Globals.IN_PROGRESS):
		direction = Vector2(-1,0)
	
	if Globals.check_dialogue_state("kill_player0", 1, Globals.DONE):
		raw_velocity = direction * speed * 1.5
		if (position.x >= 1300):
			queue_free()

# for birds, we need 2 zones ("pursuit", "flee")
# idle = -1, pursuit = 0, flee = 1

func idle_behaviour() -> void:
	default_roam(0.2)

func zone_0_behaviour() -> void:
	default_pursuit(1, true, 60)

func zone_1_behaviour() -> void:
	if atk_timer.is_stopped() && zone_number == 1:
		attack()
		atk_timer.start()
	default_flee()

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	potion_amount = floor(potion_amount)
	var deg_between_potions: float = 6
	var angle_offset_deg = -(potion_amount - 1) * deg_between_potions/2
	for i in range(potion_amount):
		var attack_angle
		if is_player:
			attack_angle = direction.angle() + deg_to_rad(angle_offset_deg)
		else:
			attack_angle = dir_to_player.angle() + deg_to_rad(angle_offset_deg)
		spawn_attack_entity(potion_scene, Vector2(cos(attack_angle), sin(attack_angle)))
		angle_offset_deg += deg_between_potions
