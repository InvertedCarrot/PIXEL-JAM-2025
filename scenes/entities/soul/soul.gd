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
	var potion_amount = 5
	var deg_between_potions: float = 6
	var angle_offset_deg = -(potion_amount - 1) * deg_between_potions/2
	for i in range(potion_amount):
		var attack_angle
		if is_player:
			attack_angle = direction.angle() + deg_to_rad(angle_offset_deg)
		else:
			attack_angle = dir_to_player.angle() + deg_to_rad(angle_offset_deg)
		spawn_attack_entity(potion_scene, Vector2(cos(attack_angle), sin(attack_angle)))
		angle_offset_deg += deg_between_potions
