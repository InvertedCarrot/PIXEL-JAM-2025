extends Entity

var scratch_scene: PackedScene = preload("res://scenes/attack_entities/scratch/scratch.tscn")

var dialogues_done = {
	"intro": false
}

func _ready() -> void:
	entity_name = "npc_cat"
	super()

func _process(delta: float) -> void:
	super(delta)
	if Globals.current_dungeon==0 and dialogues_done["intro"] and !Globals.dialogue_active:
		direction = Vector2(1,0)
		raw_velocity = direction * speed * 1.5
		 
		

func idle_behaviour() -> void:
	if Globals.current_dungeon==0 and !dialogues_done["intro"]:
		default_pursuit()
	

func zone_0_behaviour() -> void:
	if Globals.current_dungeon<=1:
		if Globals.current_dungeon==0 and !dialogues_done["intro"]:
			default_stop(false, false)
			dialogue_activate.emit("intro")
			dialogues_done["intro"] = true
			

func zone_1_behaviour() -> void:
	pass

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	var scratch = spawn_attack_entity(scratch_scene, direction)
	scratch.global_position += 100 * direction
