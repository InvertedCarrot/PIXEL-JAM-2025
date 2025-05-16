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
var NO_LAYER = 0b0000
var PLAYER_LAYER = 0b0001
var ENEMY_LAYER = 0b0010
var ATTACK_LAYER = 0b0100

# Entities metadata
var ENTITIES_DATA = {
	"cat": {
		"max_health": 100,
		"speed": 300,
		"max_momentum_scalar": 300,
		"start_position": Vector2(0,0),
		"detect_zone_ranges": [400, 300, 200, 100] as Array[float],
		"attack_cooldown": 0.5,
		"idle_position_cooldown": 2,
	},
	"bird": {
		"max_health": 5,
		"speed": 120,
		"max_momentum_scalar": 120,
		"start_position": Vector2(500, 0),
		"detect_zone_ranges": [450, 200, 0, 0] as Array[float],
		"attack_cooldown": 4,
		"idle_position_cooldown": 2,
		"strafe_timer": 0.8,
		"flee_timer": 2.5,
	},
	"fireball": {
		"max_health": 5,
		"speed": 150,
		"max_momentum_scalar": 450,
		"start_position": Vector2(500,0),
		"detect_zone_ranges": [400, 200, 0, 0] as Array[float],
		"attack_cooldown": 2,
		"idle_position_cooldown": 2,
		"fire_trail_amount": 6, # unique to fireballs
	},
	"lily": { #TODO: change value once damage is implemented
		"max_health": 3,
		"speed": 120,
		"max_momentum_scalar": 120,
		"start_position": Vector2(400, 0),
		"detect_zone_ranges": [500, 250, 0, 0] as Array[float],
		"attack_cooldown": 5,
		"idle_position_cooldown": 2,
		"strafe_timer": 1,
		"flee_timer": 3,
	},
	"reaper": {
		"max_health": 5,
		"speed": 75,
		"max_momentum_scalar": 75,
		"start_position": Vector2(-600, 0),
		"detect_zone_ranges": [500, 200, 100, 0] as Array[float],
		"attack_cooldown": 5,
		"idle_position_cooldown": 2,
	},
}


var ATTACK_ENTITIES_DATA = {
	"potion": {
		"speed": 500,
		"decceleration": 200,
		"can_bounce": false,
		"uptime_autostart": true,
		"uptime": 2,
	},
	"fire_trail": {
		"speed": 10, # DON'T CHANGE
		"decceleration": 1000, # DON'T CHANGE
		"can_bounce": false,
		"uptime_autostart": true,
		"uptime": 3,
	},
	"spore": {
		"a": 1
	},
	"scythe": {
		"a": 1
	}
}
