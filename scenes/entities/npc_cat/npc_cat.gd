extends Entity

var scratch_scene: PackedScene = preload("res://scenes/attack_entities/scratch/scratch.tscn")


func _ready() -> void:
	entity_name = "npc_cat"
	super()

func _process(delta: float) -> void:
	super(delta)
	if Globals.check_dialogue_state("intro", 0, Globals.DONE):
		direction = Vector2(1,0)
		raw_velocity = direction * speed * 1.5
		if (position.x >= 600):
			queue_free()
		

func idle_behaviour() -> void:
	if Globals.check_dialogue_state("intro", 0, Globals.NOT_STARTED):
		default_pursuit()
	

func zone_0_behaviour() -> void:
	if Globals.check_dialogue_state("intro", 0, Globals.NOT_STARTED):
		default_stop(false, false)
		dialogue_activate.emit("intro")


func zone_1_behaviour() -> void:
	pass

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	var scratch = spawn_attack_entity(scratch_scene, direction)
	scratch.global_position += 100 * direction
