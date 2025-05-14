extends Node

# For player
var health = 100

# Constants
var MAX_HEALTH = 100

# Enemies metadata
var ENTITIES_DATA = {
	"cat": {
		"speed": 400,
		"max_speed": 400,
		"start_position": Vector2(0,0),
		"detect_zone_ranges": [400, 300, 200, 100] as Array[float],
		"attack_cooldown": 0.5,
		"idle_position_cooldown": 2,
		"state_switch_cooldown": 0.7
	},
	"fireball": {
		"speed": 150,
		"max_speed": 150,
		"start_position": Vector2(500,0),
		"detect_zone_ranges": [300, 200, 0, 0] as Array[float],
		"attack_cooldown": 2,
		"idle_position_cooldown": 3,
		"state_switch_cooldown": 0.7
	},
	"reaper": {
		"speed": 150,
		"max_speed": 150,
		"start_position": Vector2(-600, 0),
		"detect_zone_ranges": [500, 200, 100, 0] as Array[float],
		"attack_cooldown": 0.5,
		"idle_position_cooldown": 3,
		"state_switch_cooldown": 0.7
	},
}
