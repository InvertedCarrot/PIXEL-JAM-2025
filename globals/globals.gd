extends Node

# For player
var player_health = 100
var multiplier = 0

# Constants
var MAX_PLAYER_HEALTH = 100
var MAX_ENEMY_HEALTH = 5
var MAX_MULTIPLIER = 10

# Layers (to set dynamically depending on whether its an enemy or player)
# Store in binary repr, each bit represents whether that layer is included or not (right to left)
# e.g. 0b0001 => only layer 1, 0b0011 => layers 1 and 2, 0b0010 => only layer 2
var PLAYER_LAYER = 0b0001
var ENEMY_LAYER = 0b0010
var PLAYER_ATTACK_LAYER = 0b0100
var ENEMY_ATTACK_LAYER = 0b1000

# Entities metadata
var ENTITIES_DATA = {
	"cat": {
		"speed": 400,
		"max_speed": 400,
		"start_position": Vector2(0,0),
		"detect_zone_ranges": [400, 300, 200, 100] as Array[float],
		"attack_cooldown": 0.5,
		"idle_position_cooldown": 2,
		"state_switch_cooldown": 0.7,
		"max_health": 100,
	},
	"fireball": {
		"speed": 150,
		"max_speed": 150,
		"start_position": Vector2(500,0),
		"detect_zone_ranges": [300, 200, 0, 0] as Array[float],
		"attack_cooldown": 2,
		"idle_position_cooldown": 3,
		"state_switch_cooldown": 0.7,
		"max_health": 5,
	},
	"reaper": {
		"speed": 150,
		"max_speed": 150,
		"start_position": Vector2(-600, 0),
		"detect_zone_ranges": [500, 200, 100, 0] as Array[float],
		"attack_cooldown": 0.5,
		"idle_position_cooldown": 3,
		"state_switch_cooldown": 0.7,
		"max_health": 5
	},
}
