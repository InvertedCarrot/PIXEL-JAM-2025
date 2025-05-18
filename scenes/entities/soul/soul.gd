extends Entity


# TODO: maybe some attack?
var potion_scene: PackedScene = preload("res://scenes/attack_entities/potion/potion.tscn")


func set_properties() -> void:
	super()

func abstract_properties_checks() -> void:
	super()

func _ready() -> void:
	entity_name = "soul"
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
	spawn_attack_entity(potion_scene, direction)
