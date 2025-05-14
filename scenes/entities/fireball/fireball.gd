extends Entity

func _ready() -> void:
	is_player = false
	start_position = Vector2(200,400)
	speed = 500
	super()

func _process(delta: float) -> void:
	#does not go to player yet
	#direction = ($"../Cat".position - position).normalized()
	#velocity = direction * speed
	#move_and_slide()
	super(delta)
