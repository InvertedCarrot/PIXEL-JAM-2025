extends Entity

func _ready() -> void:
	detect_zone_ranges = [300, 200, 0, 0]
	start_position = Vector2(300, 400)
	max_speed = 250
	speed = 150
	super()

func _process(delta: float) -> void:
	#does not go to player yet
	#direction = ($"../Cat".position - position).normalized()
	#velocity = direction * speed
	#move_and_slide()
	super(delta)


# for fireballs, we only need 2 zones ("pursuit" and "attack")
# idle = -1, pursuit = 0, attack = 1

func idle_behaviour(delta: float) -> void:
	var ipt: Timer = timers.get_node("IdlePositionTimer")
	if ipt.is_stopped():
		# choose new direction to travel
		var new_angle = randf_range(0, 2*PI)
		direction = Vector2(cos(new_angle), sin(new_angle))
		velocity = direction * speed/3
		ipt.start()

func zone_0_behaviour(delta: float) -> void:
	direction = dir_to_player
	velocity = direction * speed

func zone_1_behaviour(delta: float) -> void:
	var act: Timer = timers.get_node("AttackCooldownTimer")
	if act.is_stopped():
		direction = dir_to_player
		act.start()
	velocity = direction * speed * 2.2

func zone_2_behaviour(delta: float) -> void:
	pass

func zone_3_behaviour(delta: float) -> void:
	pass
