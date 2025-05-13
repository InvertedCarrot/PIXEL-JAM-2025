class_name Entity
extends CharacterBody2D

# @onready var player_animation = $PlayerAnimation

@export var speed: float
var direction: Vector2

# Set to false for auto-controlled characters
var can_control: bool = false

func _ready() -> void:
	position = Vector2.ZERO


func _process(delta: float) -> void:
	if (can_control):
		# get directional input and convert to unit vector
		direction = Input.get_vector("left","right","up","down")
		velocity = direction * speed
		move_and_slide() # already accounts for deltaTime
