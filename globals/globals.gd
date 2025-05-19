extends Node

# For player
var player_health = -1
var souls_harvested = 0
var max_player_health = -1
var player_entity = "cat"

# Constants
var SOUL_CAPACITY = 10

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
var TRANSITION_AREA_LAYER = 0b1000000
var CUTCENE_AREA_LAYER = 0b10000000


# Entities metadata
var ENTITIES_DATA = {
	"cat": {
		"health": 100,
		"damage": 1,
		"speed": 300,
		"max_momentum_scalar": 450,
		"detect_zone_ranges": [550, 350, 200, 125] as Array[float],
		"knockback_scalar": 300,
		"attack_cooldown": 1.5,
		"idle_position_cooldown": 2,
		"strafe_timer": 1,
		"flee_timer": 2,
		"state_switch_cooldown": 15
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
	"soul": {
		"health": 10,
		"damage": 0,
		"speed": 300,
		"max_momentum_scalar": 500,
		"detect_zone_ranges": [0, 0, 0, 0] as Array[float],
		"knockback_scalar": 50,
		"attack_cooldown": 0.5,
		"idle_position_cooldown": 5,
	},
	"npc_cat":{
		"health": 10,
		"damage": 0,
		"speed": 200,
		"max_momentum_scalar": 1,
		"detect_zone_ranges": [150, 0, 0, 0] as Array[float],
		"knockback_scalar": 1,
		"attack_cooldown": 1,
		"idle_position_cooldown": 1,
	}
}


var ATTACK_ENTITIES_DATA = {
	"scratch": {
		"damage": 3,
		"speed": 1,
		"decceleration": 1000, # DON'T CHANGE
		"knockback_scalar": 200,
		"uptime_autostart": true,
		"can_bounce": false,
		"remove_upon_hit": false,
		"uptime": 1,
	},
	"potion": {
		"damage": 20,
		"speed": 500,
		"decceleration": 200,
		"knockback_scalar": 150,
		"uptime_autostart": true,
		"can_bounce": true,
		"remove_upon_hit": true,
		"uptime": 2,
	},
	"fire_trail": {
		"damage": 1,
		"speed": 10, # DON'T CHANGE
		"decceleration": 1000, # DON'T CHANGE
		"knockback_scalar": 100,
		"uptime_autostart": true,
		"can_bounce": true,
		"remove_upon_hit": false,
		"uptime": 3,
	},
	"spore": {
		"damage": 2,
		"speed": 500,
		"decceleration": 1000,
		"knockback_scalar": 0,
		"uptime_autostart": true,
		"can_bounce": false,
		"remove_upon_hit": false,
		"uptime": 5
	},
	"scythe": {
		"damage": 5,
		"speed": 225,
		"decceleration": 0,
		"knockback_scalar": 400,
		"uptime_autostart": false,
		"can_bounce": true,
		"remove_upon_hit": false,
		"uptime": 6,
	}
}

## Level maintaining
var current_dungeon = 0


## Dialogues

var dialogue_active: bool = false

var dialogue_scene: String = ""

var dialogue_index: int = 0

var dialogues_in_order = ["intro"]

const DIALOGUE_BOX_SCENE = preload("res://scenes/UI/dialogue/dialogue_box.tscn")

var CUTSCENES_GDSCRIPT = load("res://scenes/UI/dialogue/dialogue_logs.gd")

# Dialogue states
enum{
	NOT_STARTED,
	IN_PROGRESS, 
	DONE
}

# This is to ensure specific actions happen during states of dialogues
var dialogue_stages = {
	"intro": NOT_STARTED
}

func check_dialogue_state(dialogue: String, dungeon: int, state) -> bool:
	## Check if dialogue is in a given state in a given dungeon
	return dungeon==current_dungeon and dialogue_stages[dialogue]==state

## Entity potrait info

var current_speaker = ""

var player_portraits = {
	"bird": load("res://assets/portraits/bird_portrait.png"),
	"cat": load("res://assets/portraits/cat_portrait.png"),
	"fireball": load("res://assets/portraits/fireball_portrait.png"),
	"lily": load("res://assets/portraits/lily_portrait.png"),
	"reaper": load("res://assets/portraits/reaper_portrait.png"),
	"soul": load("res://assets/portraits/soul_portrait.png"),
	"npc": load("res://assets/portraits/black_cat_portrait.png")
}

var player_portrait_outlines = {
	"bird": Color("#3d3d3d"),
	"cat": Color("#bd810e"),
	"fireball": Color("#aa20ff"),
	"lily": Color("#266700"),
	"reaper": Color("#00376e"),
	"soul": Color("#a6e7ff"),
	"npc": Color("#a6e7ff"),
}

var player_portrait_backgrounds = {
	"bird": Color("#b2b2b2"),
	"cat": Color("#fce9c7"),
	"fireball": Color("#8101c5"),
	"lily": Color("#ffd3ef"),
	"reaper": Color("#6d8bbf"),
	"soul": Color("#6d9aab"),
	"npc": Color("#a6e7ff"),
}
