extends AttackEntity

func set_properties() -> void:
	super()
	uptime_timer.wait_time *= randf_range(0.9, 1.1)
	speed *= randf_range(0.5, 1)

func _ready() -> void:
	attack_entity_name = "spore"
	super()
	scale_spore(randf_range(0.6, 0.8))
	

func _process(delta: float) -> void:
	super(delta)

func scale_spore(scale_factor: float) -> void:
	$EntityImage.scale *= Vector2(scale_factor, scale_factor)
	hitbox_shape.shape.radius *= scale_factor
