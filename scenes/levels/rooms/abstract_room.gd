extends Node2D

@export var num_enemies = {
	"bird": 0,
	"cat": 0,
	"fireball": 0,
	"lily": 0,
	"reaper": 0,
}

func _ready():
	if (!num_enemies.has_all(["cat","bird","fireball","lily","reaper"]) or num_enemies.size()!=5):
		assert(false, "ERROR: Enemies dict must contain the exact enemy names")
	for enemy in num_enemies:
		if (type_string(typeof(num_enemies[enemy]))!="int" || num_enemies[enemy] < 0):
			assert(false, "ERROR: Enter a valid number for the number of entities")



func _process(_delta):
	pass

func get_spawn_positions():
	return %SpawnPositions.get_children()

func get_enemies_to_spawn():
	return num_enemies
