extends CharacterBody2D

@onready var player_animation = $PlayerAnimation
var pointing_direction = 0

func _ready() -> void:
	position = Vector2(50,50)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# directional input
	var direction: Vector2 = Input.get_vector("left","right","up","down")
	velocity = direction * 500
	if velocity.x!=0:
		player_animation.play("new_animation")
		player_animation.advance(0)
	else:
		player_animation.stop()
	
	# -1 for left, 1 for right, 0 otherwise
	pointing_direction = Input.get_axis("left","right")
	if pointing_direction<0:
		$PlayerImage.flip_h = true
	else:
		$PlayerImage.flip_h = false
	
	move_and_slide()
