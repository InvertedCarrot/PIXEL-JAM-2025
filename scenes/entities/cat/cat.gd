extends Entity

var scratch_scene: PackedScene = preload("res://scenes/attack_entities/scratch/scratch.tscn")

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
	var scratch = spawn_attack_entity(scratch_scene, direction)
	scratch.global_position += 100 * direction
