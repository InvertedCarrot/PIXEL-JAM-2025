extends AttackEntity

func _ready() -> void:
	attack_entity_name = "potion"
	super()

func _process(delta: float) -> void:
	super(delta)


func destroy():
	queue_free()
