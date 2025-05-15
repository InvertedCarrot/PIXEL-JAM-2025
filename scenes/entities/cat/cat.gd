extends Entity


func _ready() -> void:
	entity_name = "cat"
	set_properties()
	is_player = true
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
	pass

func damage():
	pass
