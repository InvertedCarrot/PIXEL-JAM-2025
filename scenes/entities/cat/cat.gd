extends Entity


func _ready() -> void:
	entity_name = "cat"
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
	momentum = direction * speed * 1.1 # i just made it's attack a dash for now
	pass

func damage():
	pass
