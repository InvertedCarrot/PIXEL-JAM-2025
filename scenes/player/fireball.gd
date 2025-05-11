extends CharacterBody2D


@onready var player_animation = $PlayerAnimation
var speed = 500
var direction: Vector2


func _ready() -> void:
	position = Vector2.ZERO


func _process(delta: float) -> void:
	
	# directional input
	direction = Input.get_vector("left","right","up","down") # unit vector
	velocity = direction * speed



func _physics_process(delta: float) -> void:
	move_and_slide()
