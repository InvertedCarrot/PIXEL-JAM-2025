extends Node2D


@export var animation_tree: AnimationTree
@onready var player = get_owner()

var last_facing_direction: Vector2

func _physics_process(delta: float) -> void:
	
	var is_idle = (player.direction == Vector2.ZERO)
	# if moving, update the player's direction
	# else, keep track of the player's last direction since standing still
	if !is_idle:
		last_facing_direction = player.direction

	
	# set blend positions wrt player's direction
	animation_tree.set("parameters/Run/blend_position", last_facing_direction)
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
