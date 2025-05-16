extends Entity

var potion_scene: PackedScene = preload("res://scenes/attack_entities/potion/potion.tscn")

func _ready() -> void:
	entity_name = "bird"
	super()

func _process(delta: float) -> void:
	super(delta)

# for birds, we need 2 zones ("pursuit", "flee")
# idle = -1, pursuit = 0, flee = 1

func idle_behaviour() -> void:
	default_roam(0.2)

func zone_0_behaviour() -> void:
	default_pursuit(1, true, 60)

func zone_1_behaviour() -> void:
	if atk_timer.is_stopped() && calculate_zone() == 1:
		attack()
		atk_timer.start()
	default_flee()

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	spawn_attack_entity(potion_scene)

func take_damage():
	pass # reduces enemy health
