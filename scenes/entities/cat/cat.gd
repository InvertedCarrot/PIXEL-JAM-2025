extends Entity

var potion_scene: PackedScene = preload("res://scenes/attack_entities/potion/potion.tscn")

func _ready() -> void:
	entity_name = "cat"
	super()

func _process(delta: float) -> void:
	super(delta)

func idle_behaviour() -> void:
	pass

func zone_0_behaviour() -> void:
	pass

func zone_1_behaviour() -> void:
	pass

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	var potion = potion_scene.instantiate()
	potion.start_global_position = global_position
	potion.start_direction = direction
	%AttackEntities.add_child(potion)

func take_damage():
	pass
