extends Node

# For player
var player_health: float = -1
var souls_harvested: float = 0
var max_player_health: float = -1
var player_entity: String = "cat"

# Constants
var SOUL_CAPACITY: float = 10

# enemy damage scaling
var enemy_damage_scale = 1

# Layers (to set dynamically depending on whether its an enemy or player)
# Store in binary repr, each bit represents whether that layer is included or not (right to left)
# e.g. 0b0001 => only layer 1, 0b0011 => layers 1 and 2, 0b0010 => only layer 2
var NO_LAYER = 0b0000
var PLAYER_LAYER = 0b0001
var ENEMY_LAYER = 0b0010
var PLAYER_ATTACK_LAYER = 0b0100
var WALL_LAYER = 0b1000
var DEAD_ENEMIES_LAYER = 0b10000
var ENEMY_ATTACK_LAYER = 0b100000



func damage_scale_function(x):
	# a function that interpolates from (0, 0) to (1, 1)
	return x # keep as linear func for now

# Entities metadata
func same(value): return [value, value]
const no_data = [1, 1]
var ENTITIES_DATA = {
	"cat": {
		"health": same(100),
		"damage": same(1),
		"speed": same(150),
		"max_momentum_scalar": same(450),
		"detect_zone_ranges": [550, 350, 200, 125] as Array[float],
		"knockback_scalar": same(300),
		"attack_cooldown": same(1.5),
		"idle_position_cooldown": same(2),
		"strafe_timer": same(1),
		"flee_timer": same(2),
		"state_switch_cooldown": same(15)
	},
	"bird": {
		"health": [7, 15],
		"damage": same(1),
		"speed": [120, 240],
		"max_momentum_scalar": same(400),
		"detect_zone_ranges": [450, 200, 0, 0] as Array[float],
		"knockback_scalar": same(150),
		"attack_cooldown": [3, 2],
		"idle_position_cooldown": [2, 1],
		"strafe_timer": [0.8, 0.6],
		"flee_timer": [2.5, 2],
		"potion_amount": [2, 10],
	},
	"fireball": {
		"health": [5, 15],
		"damage": [3, 6],
		"speed": [150, 300],
		"max_momentum_scalar": same(500),
		"detect_zone_ranges": [400, 200, 0, 0] as Array[float],
		"knockback_scalar": [150, 200],
		"attack_cooldown": [4, 3],
		"idle_position_cooldown": same(2),
		"strafe_timer": no_data,
		"flee_timer": no_data,
		"fire_trail_amount": [6, 15], # unique to fireballs
	},
	"lily": {
		"health": [10, 20],
		"damage": same(1),
		"speed": [120, 200],
		"max_momentum_scalar": same(300),
		"detect_zone_ranges": [500, 250, 0, 0] as Array[float],
		"knockback_scalar": [200, 250],
		"attack_cooldown": [4, 3],
		"idle_position_cooldown": same(2),
		"strafe_timer": [1, 0.8],
		"flee_timer": no_data,
		"spore_amount": [20, 50]
	},
	"reaper": {
		"health": [15, 25],
		"damage": [2, 3],
		"speed": [75, 120],
		"max_momentum_scalar": same(200),
		"detect_zone_ranges": [500, 200, 100, 0] as Array[float],
		"knockback_scalar": [250, 350],
		"attack_cooldown": [6, 4],
		"idle_position_cooldown": same(2),
		"strafe_timer": no_data,
		"flee_timer": no_data,
	},
	"soul": {
		"health": same(10),
		"damage": same(0),
		"speed": same(300),
		"max_momentum_scalar": same(500),
		"detect_zone_ranges": [0, 0, 0, 0] as Array[float],
		"knockback_scalar": same(50),
		"attack_cooldown": same(0.5),
		"idle_position_cooldown": no_data,
		"strafe_timer": no_data,
		"flee_timer": no_data,
	},
	"npc_cat":{
		"health": same(10),
		"damage": same(0),
		"speed": same(200),
		"max_momentum_scalar": same(1),
		"detect_zone_ranges": [150, 0, 0, 0] as Array[float],
		"knockback_scalar": same(1),
		"attack_cooldown": same(1),
		"idle_position_cooldown": same(1),
		"strafe_timer": no_data,
		"flee_timer": no_data,
	}
}


var ATTACK_ENTITIES_DATA = {
	"scratch": { 
		"damage": [3, 6],
		"speed": same(0), # DON'T CHANGE: NO SPEED
		"decceleration": same(1000), # DON'T CHANGE, NO MOVEMENT
		"knockback_scalar": [200, 300],
		"uptime": same(1), # DON'T CHANGE
		"uptime_autostart": true,
		"can_bounce": false,
		"remove_upon_hit": false,
	},
	"potion": {
		"damage": [2, 5],
		"speed": [300, 600],
		"decceleration": [200, 180],
		"knockback_scalar": [150, 180],
		"uptime": [2, 3],
		"uptime_autostart": true,
		"can_bounce": true,
		"remove_upon_hit": true,
	},
	"fire_trail": {
		"damage": [1, 2],
		"speed": same(10), # DON'T CHANGE
		"decceleration": same(1000), # DON'T CHANGE
		"knockback_scalar": [100, 150],
		"uptime": [3, 4],
		"uptime_autostart": true,
		"can_bounce": true,
		"remove_upon_hit": false,
	},
	"spore": {
		"damage": [2, 4],
		"speed": [400, 700],
		"decceleration": [1000, 900],
		"knockback_scalar": same(0),
		"uptime": [5, 6],
		"uptime_autostart": true,
		"can_bounce": false,
		"remove_upon_hit": false,
	},
	"scythe": {
		"damage": [5, 10],
		"speed": [175, 250],
		"decceleration": same(0),
		"knockback_scalar": [400, 500],
		"uptime": [5, 7],
		"uptime_autostart": false,
		"can_bounce": true,
		"remove_upon_hit": false,
	}
}

## Dialogues

var dialogue_active: bool = false

var dialogue_scene: String = "start"

const DIALOGUE_BOX_SCENE = preload("res://scenes/UI/dialogue/dialogue_box.tscn")

var CUTSCENES_GDSCRIPT = load("res://scenes/UI/dialogue/dialogue_logs.gd")

# Level maintaining
var current_dungeon = 0
