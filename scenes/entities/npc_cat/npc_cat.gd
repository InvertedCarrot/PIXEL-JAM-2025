extends Entity

var scratch_scene: PackedScene = preload("res://scenes/attack_entities/scratch/scratch.tscn")


func _ready() -> void:
	entity_name = "npc_cat"
	super()

func _process(delta: float) -> void:
	super(delta)
	if Globals.check_dialogue_state("intro", 0, Globals.DONE):
		if (!(position.y >=0 && position.y <=100)):
			direction = Vector2(0, -1*abs(position.y)/position.y)
		else:
			direction = Vector2(1,0)
		raw_velocity = direction * speed * 1.5
		if (position.x >= 800):
			queue_free()

	if Globals.check_dialogue_state("kill_player0", 1, Globals.DONE):
		if (!(position.y >=0 && position.y <=100)): 
			direction = Vector2(0, -1*abs(position.y)/position.y)
		else:
			direction = Vector2(1,0)
		raw_velocity = direction * speed * 1.5
		if (position.x >= 1300):
			queue_free()
			dialogue_activate.emit("kill_player1", "reaper")

func idle_behaviour() -> void:
	if Globals.check_dialogue_state("intro", 0, Globals.NOT_STARTED):
		default_pursuit()
	if (Globals.check_dialogue_state("first_fight", 1, Globals.DONE) and 
			Globals.check_dialogue_state("kill_player0",1,Globals.NOT_STARTED)):
		default_pursuit()
	if Globals.current_dungeon==6:
		default_pursuit()
	
func zone_0_behaviour() -> void:
	if Globals.check_dialogue_state("intro", 0, Globals.NOT_STARTED):
		default_stop(false, false)
		dialogue_activate.emit("intro", "npc")
	if Globals.check_dialogue_state("kill_player0", 1, Globals.NOT_STARTED):
		default_stop(false, false)
	if Globals.current_dungeon==6:
		default_stop(false, false)
	

func zone_1_behaviour() -> void:
	pass

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	var scratch = spawn_attack_entity(scratch_scene, direction)
	scratch.global_position += 100 * direction
