extends Entity

func _ready() -> void:
	can_control = false
	start_position = Vector2(500,500)
	super()

func _process(delta: float) -> void:
	direction = ($"../Cat".position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	super(delta)
