extends Entity

func _ready() -> void:
	can_control = false
	start_position = Vector2(200,200)
	super()

func _process(delta: float) -> void:
	#does not go to player yet
	#direction = ($"../Cat".position - position).normalized()
	#velocity = direction * speed
	#move_and_slide()
	super(delta)
