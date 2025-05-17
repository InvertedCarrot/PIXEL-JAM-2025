extends Node

# For player
var player_health = -1
var multiplier = 0
var max_player_health = -1

# Constants
var MAX_MULTIPLIER = 10

# Layers (to set dynamically depending on whether its an enemy or player)
# Store in binary repr, each bit represents whether that layer is included or not (right to left)
# e.g. 0b0001 => only layer 1, 0b0011 => layers 1 and 2, 0b0010 => only layer 2
var NO_LAYER = 0b0000
var PLAYER_LAYER = 0b0001
var ENEMY_LAYER = 0b0010
var ATTACK_LAYER = 0b0100
var WALL_LAYER = 0b1000

# Entities metadata
var ENTITIES_DATA = {
	"cat": {
		"health": 20,
		"damage": 1,
		"speed": 300,
		"max_momentum_scalar": 400,
		"detect_zone_ranges": [400, 300, 200, 100] as Array[float],
		"knockback_scalar": 150,
		"attack_cooldown": 1,
		"idle_position_cooldown": 2,
	},
	"bird": {
		"health": 7,
		"damage": 1,
		"speed": 120,
		"max_momentum_scalar": 400,
		"detect_zone_ranges": [450, 200, 0, 0] as Array[float],
		"knockback_scalar": 150,
		"attack_cooldown": 3,
		"idle_position_cooldown": 2,
		"strafe_timer": 0.8,
		"flee_timer": 2.5,
		"potion_amount": 2,
	},
	"fireball": {
		"health": 5,
		"damage": 3,
		"speed": 150,
		"max_momentum_scalar": 500,
		"detect_zone_ranges": [400, 200, 0, 0] as Array[float],
		"knockback_scalar": 150,
		"attack_cooldown": 4,
		"idle_position_cooldown": 2,
		"fire_trail_amount": 6, # unique to fireballs
	},
	"lily": {
		"health": 10,
		"damage": 1,
		"speed": 120,
		"max_momentum_scalar": 300,
		"detect_zone_ranges": [500, 250, 0, 0] as Array[float],
		"knockback_scalar": 200,
		"attack_cooldown": 4,
		"idle_position_cooldown": 2,
		"strafe_timer": 1,
		"spore_amount": 20
	},
	"reaper": {
		"health": 15,
		"damage": 1,
		"speed": 75,
		"max_momentum_scalar": 200,
		"detect_zone_ranges": [500, 200, 100, 0] as Array[float],
		"knockback_scalar": 250,
		"attack_cooldown": 6,
		"idle_position_cooldown": 2,
	},
}


var ATTACK_ENTITIES_DATA = {
	"scratch": {
		"damage": 3,
		"speed": 1,
		"decceleration": 1000, # DON'T CHANGE
		"knockback_scalar": 200,
		"uptime_autostart": true,
		"remove_upon_hit": false,
		"uptime": 1,
	},
	"potion": {
		"damage": 2,
		"speed": 500,
		"decceleration": 200,
		"knockback_scalar": 150,
		"uptime_autostart": true,
		"remove_upon_hit": true,
		"uptime": 2,
	},
	"fire_trail": {
		"damage": 1,
		"speed": 10, # DON'T CHANGE
		"decceleration": 1000, # DON'T CHANGE
		"knockback_scalar": 100,
		"uptime_autostart": true,
		"remove_upon_hit": false,
		"uptime": 3,
	},
	"spore": {
		"damage": 2,
		"speed": 500,
		"decceleration": 1000,
		"knockback_scalar": 0,
		"uptime_autostart": true,
		"remove_upon_hit": false,
		"uptime": 5
	},
	"scythe": {
		"damage": 5,
		"speed": 225,
		"decceleration": 0,
		"knockback_scalar": 400,
		"uptime_autostart": false,
		"remove_upon_hit": false,
		"uptime": 6,
	}
}
