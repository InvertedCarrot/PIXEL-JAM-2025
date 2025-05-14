class_name Entity
extends CharacterBody2D

@onready var zones = $DetectZones.get_children()
@onready var player_node = %Player.get_child(0)
@onready var timers = $Timers
@export var detect_zone_ranges: Array[float]

var speed: float

var dist_to_player: float
var dir_to_player: Vector2

var direction: Vector2

var is_player: bool = false
var start_position = Vector2.ZERO


func _ready() -> void:
	position = start_position
	if detect_zone_ranges.size() != 4:
		detect_zone_ranges = [500, 300, 200, 100]
	# set area2D sizes for visual clarity
	if (!speed):
		assert(false,"Speed must be defined!")

	for i in range(zones.size()):
		var zone = zones[i]
		var collision_shape = zone.get_node("CollisionShape2D")
		collision_shape.shape.radius = detect_zone_ranges[i]


func _process(delta: float) -> void:
	if (!is_player):
		dist_to_player = global_position.distance_to(player_node.global_position)
		dir_to_player = (global_position - player_node.global_position).normalized()
		# print(calculate_zone())
	
	
	if (is_player):
		# get directional input and convert to unit vector
		direction = Input.get_vector("left","right","up","down")
		velocity = direction * speed
		move_and_slide() # already accounts for deltaTime


func calculate_zone():
	var zone_num: int = -1
	for zone_dist in detect_zone_ranges:
		if dist_to_player >= zone_dist:
			break
		zone_num += 1
	return zone_num # return -1 if outside all zones


func turn_into_player():
	pass


func turn_into_enemy():
	pass
