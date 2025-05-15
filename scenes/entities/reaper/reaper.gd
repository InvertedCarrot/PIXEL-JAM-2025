extends Entity

func _ready() -> void:
	entity_name = "reaper"
	is_player = false
	super()

func _process(delta: float) -> void:
	super(delta)



# for reapers, we need 3 zones ("pursuit", "stalk" and "attack")
# idle = -1, pursuit = 0, stalk = 1, attack = 2

func idle_behaviour() -> void:
	var ipt: Timer = timers.get_node("IdlePositionTimer")
	if ipt.is_stopped():
		# choose new direction to travel
		var new_angle = randf_range(0, 2*PI)
		direction = Vector2(cos(new_angle), sin(new_angle))
		velocity = direction * speed
		ipt.start()

func zone_0_behaviour() -> void:
	direction = dir_to_player
	velocity = direction * speed

func zone_1_behaviour() -> void:
	# do nothing, he just kinda stands there
	direction = dir_to_player # need this bc the AnimationTree uses direction to face the right way
	momentum = velocity # let velocity decay to 0
	velocity = Vector2.ZERO

func zone_2_behaviour() -> void:
	# completely stand still and attack
	direction = dir_to_player
	momentum = Vector2.ZERO
	velocity = Vector2.ZERO
	attack()

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	pass # swings a scythe at you but don't have the asset yet

func damage():
	pass # reduces enemy health
