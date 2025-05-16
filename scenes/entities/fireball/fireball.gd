extends Entity

var fire_trail_scene: PackedScene = preload("res://scenes/attack_entities/fire_trail/fire_trail.tscn")

var fire_trail_amount: float


func set_properties() -> void:
	super()
	fire_trail_amount = entity_data["fire_trail_amount"]

func abstract_properties_checks() -> void:
	super()
	if (!fire_trail_amount):
		assert(false, "Error: fire_trail_amount must be defined")

func _ready() -> void:
	entity_name = "fireball"
	super()

func _process(delta: float) -> void:
	super(delta)

# for fireballs, we need 2 zones ("pursuit" and "attack")
# idle = -1, pursuit = 0, attack = 1

func idle_behaviour() -> void:
	default_roam(0.3)

func zone_0_behaviour() -> void:
	default_pursuit()

func zone_1_behaviour() -> void:
	if atk_timer.is_stopped():
		direction = dir_to_player
		attack()
		atk_timer.start()
	raw_velocity = Vector2.ZERO

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	momentum = direction * max_momentum_scalar # increase speed when dashing at player
	for i in range(fire_trail_amount):
		var fire_trail_entity: Node = spawn_attack_entity(fire_trail_scene)
		fire_trail_entity.velocity = momentum * (i+0.8)/fire_trail_amount
		fire_trail_entity.decceleration = friction
		


func take_damage():
	pass
