extends Entity

func _ready() -> void:
	entity_name = "fireball"
	is_player = false
	super()

func _process(delta: float) -> void:
	super(delta)

# for fireballs, we need 2 zones ("pursuit" and "attack")
# idle = -1, pursuit = 0, attack = 1

func idle_behaviour() -> void:
	var ipt: Timer = timers.get_node("IdlePositionTimer")
	if ipt.is_stopped():
		# choose new direction to travel
		var new_angle = randf_range(0, 2*PI)
		direction = Vector2(cos(new_angle), sin(new_angle))
		velocity = direction * speed/3
		ipt.start()

func zone_0_behaviour() -> void:
	direction = dir_to_player
	velocity = direction * speed

func zone_1_behaviour() -> void:
	var act: Timer = timers.get_node("AttackCooldownTimer")
	if act.is_stopped():
		direction = dir_to_player
		attack()
		act.start()
	velocity = Vector2.ZERO

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	momentum = direction * speed * 3 # increase speed when dashing at player

func damage():
	pass
