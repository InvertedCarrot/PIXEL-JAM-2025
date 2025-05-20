extends Entity

var scythe_scene: PackedScene = preload("res://scenes/attack_entities/scythe/scythe.tscn")

func _ready() -> void:
	entity_name = "strong_reaper"
	super()

func _process(delta: float) -> void:
	super(delta)
	if Globals.check_dialogue_state("kill_player1", 1, Globals.DONE):
		## When the player dies
		if (is_player):
			dialogue_activate.emit("player_dead", "reaper")
	
	
	
# for reapers, we need 3 zones ("pursuit", "stalk" and "attack")
# idle = -1, pursuit = 0, stalk = 1, attack = 2

func idle_behaviour() -> void:
	default_roam(1)
	if atk_timer.is_stopped():
		attack()
		atk_timer.start()


func zone_0_behaviour() -> void:
	default_pursuit()
	if atk_timer.is_stopped():
		attack()
		atk_timer.start()

func zone_1_behaviour() -> void:
	default_stop()
	if atk_timer.is_stopped():
		attack()
		atk_timer.start()

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	spawn_attack_entity(scythe_scene, direction)
