extends Entity

func _ready() -> void:
	entity_name = "lily"
	super()

func _process(delta: float) -> void:
	super(delta)

# for reapers, we need 3 zones ("pursuit", "stalk" and "attack")
# idle = -1, pursuit = 0, stalk = 1, attack = 2

func idle_behaviour() -> void:
	pass

func zone_0_behaviour() -> void:
	idle_behaviour()

func zone_1_behaviour() -> void:
	idle_behaviour()

func zone_2_behaviour() -> void:
	idle_behaviour()

func zone_3_behaviour() -> void:
	idle_behaviour()

func attack() -> void:
	pass # swings a scythe at you but don't have the asset yet

func take_damage():
	pass # reduces enemy health
