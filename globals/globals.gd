extends Node

# For player
var player_health: float = -1
var souls_harvested: float = 0
var max_player_health: float = -1
var player_entity: String = "cat"

# Constants
var SOUL_CAPACITY: float = 20

# enemy damage scaling
var enemy_damage_scale = 0.2

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



func damage_scale_function(x):
	# a function that interpolates from (0, 0) to (1, 1)
	return x # keep as linear func for now

# Entities metadata
func same(value): return [value, value]
const no_data = [1, 1]
var ENTITIES_DATA = {
	"cat": {
		"health": [100, 120],
		"damage": [1, 3],
		"speed": [250, 280],
		"max_momentum_scalar": [300, 500],
		"detect_zone_ranges": [550, 350, 200, 125] as Array[float],
		"knockback_scalar": [200, 400],
		"attack_cooldown": [1, 1.2],
		"idle_position_cooldown": same(1.5),
		"strafe_timer": same(0.8),
		"flee_timer": same(1.5),
		"state_switch_cooldown": same(13)
	},
	"bird": {
		"health": [7, 15],
		"damage": same(1),
		"speed": [120, 240],
		"max_momentum_scalar": same(400),
		"detect_zone_ranges": [450, 200, 0, 0] as Array[float],
		"knockback_scalar": same(150),
		"attack_cooldown": [3, 2],
		"idle_position_cooldown": [2, 1.5],
		"strafe_timer": [0.8, 0.6],
		"flee_timer": [2.5, 1.8],
		"potion_amount": [2,10],
	},
	"fireball": {
		"health": [5, 10],
		"damage": [3, 6],
		"speed": [150, 300],
		"max_momentum_scalar": [300, 500],
		"detect_zone_ranges": [400, 200, 0, 0] as Array[float],
		"knockback_scalar": [125, 200],
		"attack_cooldown": [4, 2],
		"idle_position_cooldown": same(2),
		"strafe_timer": no_data,
		"flee_timer": no_data,
		"fire_trail_amount": [4, 15], # unique to fireballs
	},
	"lily": {
		"health": [10, 20],
		"damage": [1, 2],
		"speed": [120, 200],
		"max_momentum_scalar": same(300),
		"detect_zone_ranges": [500, 250, 0, 0] as Array[float],
		"knockback_scalar": [200, 250],
		"attack_cooldown": [4, 3],
		"idle_position_cooldown": same(2),
		"strafe_timer": [1, 0.8],
		"flee_timer": no_data,
		"spore_amount": [20, 80]
	},
	"reaper": {
		"health": [15, 30],
		"damage": [2, 4],
		"speed": [100, 150],
		"max_momentum_scalar": same(200),
		"detect_zone_ranges": [500, 200, 100, 0] as Array[float],
		"knockback_scalar": [250, 350],
		"attack_cooldown": [6, 3.5],
		"idle_position_cooldown": same(2),
		"strafe_timer": no_data,
		"flee_timer": no_data,
	},
	"strong_reaper": {
		"health": same(1000),
		"damage": same(50),
		"speed": same(100),
		"max_momentum_scalar": same(200),
		"detect_zone_ranges": [500, 200, 0, 0] as Array[float],
		"knockback_scalar": same(300),
		"attack_cooldown": same(0.2),
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
	},
	"evil_soul": {
		"health": no_data,
		"damage": no_data,
		"speed": no_data,
		"max_momentum_scalar": no_data,
		"detect_zone_ranges": [0, 0, 0, 0] as Array[float],
		"knockback_scalar": no_data,
		"attack_cooldown": no_data,
		"idle_position_cooldown": no_data,
		"strafe_timer": no_data,
		"flee_timer": no_data,
	},
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
		"uptime": [3, 4.5],
		"uptime_autostart": true,
		"can_bounce": true,
		"remove_upon_hit": false,
	},
	"spore": {
		"damage": [2, 4],
		"speed": [400, 700],
		"decceleration": [1000, 900],
		"knockback_scalar": same(0),
		"uptime": [4, 6],
		"uptime_autostart": true,
		"can_bounce": false,
		"remove_upon_hit": false,
	},
	"scythe": {
		"damage": [5, 10],
		"speed": [175, 300],
		"decceleration": same(0),
		"knockback_scalar": [400, 500],
		"uptime": [5, 8],
		"uptime_autostart": false,
		"can_bounce": true,
		"remove_upon_hit": false,
	},
	"strong_scythe": {
		"damage": same(40),
		"speed": same(300),
		"decceleration": same(0),
		"knockback_scalar": same(400),
		"uptime": same(4),
		"uptime_autostart": false,
		"can_bounce": true,
		"remove_upon_hit": false,
	}
}

## Level maintaining
var current_dungeon = 0


## Dialogues

var dialogue_active: bool = false

var dialogue_scene: String = ""

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
	"intro": NOT_STARTED,
	"first_fight": NOT_STARTED,
	"bird_dead": NOT_STARTED,
	"kill_player0": NOT_STARTED,
	"kill_player1": NOT_STARTED,
	"player_dead": NOT_STARTED,
	"evil_soul_possess": NOT_STARTED,
	"level2_start": NOT_STARTED,
	"possessing_tutorial": NOT_STARTED,
	"possessed_tutorial": NOT_STARTED,
	"final_boss_intro": NOT_STARTED,
	"game_over": NOT_STARTED
}

var dialogue_starters={
	"intro": "npc",
	"first_fight": "npc",
	"bird_dead": "npc",
	"kill_player0": "npc",
	"kill_player1": "cat",
	"player_dead": "soul",
	"evil_soul_possess": "evil_soul",
	"level2_start": "cat",
	"possessing_tutorial": "soul",
	"possessed_tutorial": "bird",
	"final_boss_intro": "npc",
	"game_over": "evil_soul"
}

var dialogue_index: int = 0

var dialogues_in_order = dialogue_stages.keys()

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
	"strong_reaper": load("res://assets/portraits/reaper_portrait.png"),
	"soul": load("res://assets/portraits/soul_portrait.png"),
	"npc": load("res://assets/portraits/black_cat_portrait.png"),
	"evil_soul": load("res://assets/portraits/evil_soul_portrait.png")
}

var player_portrait_outlines = {
	"bird": Color("#3d3d3d"),
	"cat": Color("#bd810e"),
	"fireball": Color("#aa20ff"),
	"lily": Color("#266700"),
	"strong_reaper": Color("#00376e"),
	"reaper": Color("#00376e"),
	"soul": Color("#a6e7ff"),
	"evil_soul": Color("#ff5567"),
	"npc": Color("#a6e7ff"),
}

var player_portrait_backgrounds = {
	"bird": Color("#b2b2b2"),
	"cat": Color("#fce9c7"),
	"fireball": Color("#dfc1ff"),
	"lily": Color("#ffd3ef"),
	"strong_reaper": Color("#00376e"),
	"reaper": Color("#6d8bbf"),
	"soul": Color("#6d9aab"),
	"evil_soul": Color("#ffcbd1"),
	"npc": Color("#a6e7ff"),
}
