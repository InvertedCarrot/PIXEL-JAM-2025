extends AttackEntity

func _ready() -> void:
	attack_entity_name = "fire_trail"
	super()

func _process(delta: float) -> void:
	super(delta)
