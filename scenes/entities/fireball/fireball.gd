extends Entity

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
	if atkTimer.is_stopped():
		direction = dir_to_player
		attack()
		atkTimer.start()
	raw_velocity = Vector2.ZERO

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	momentum = direction * max_momentum_scalar # increase speed when dashing at player

func take_damage():
	pass
