extends AttackEntity

var start_moving = false

func _ready() -> void:
	attack_entity_name = "scythe"
	super()
	hitbox_shape.disabled = true
	$EntityImage.modulate.a = 0.0

func _process(delta: float) -> void:
	if !start_moving:
		var tween = get_tree().create_tween()
		tween.tween_property($EntityImage, "modulate:a", 1.0, 2)
		await tween.finished
		hitbox_shape.disabled = false
		uptime_timer.start()
		start_moving = true
	if start_moving:
		super(delta)
