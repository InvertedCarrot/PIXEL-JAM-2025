extends AttackEntity

func set_properties() -> void:
	super()

func _ready() -> void:
	attack_entity_name = "scratch"
	super()
	

func _process(delta: float) -> void:
	super(delta)

func destroy() -> void:
	queue_free()
