extends CanvasLayer

var entity: Entity
var is_connected: bool = false

var dialogue_box: DialogueBox = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#entity = get_tree().get_nodes_in_group("Entity")[0]
	$DialogueBox.queue_free()


func start(scene: String):
	if (dialogue_box==null):
		dialogue_box = Globals.DIALOGUE_BOX_SCENE.instantiate()
		dialogue_box.dialogue_gdscript = Globals.get_cutscene_file(scene)
		# add dialogue_box as child
		add_child(dialogue_box)
		dialogue_box.begin()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#dialogue_box.visible = Globals.dialogue_active
	if (!is_connected):
		entity = get_tree().get_nodes_in_group("Entity")[0]
		# This line tells the script to call start() when entity emits the dialogue_activate signal\
		if (entity): 
			print("Entity connected")
			entity.connect("dialogue_activate", start)
			is_connected = true
	
	if (!Globals.dialogue_active and dialogue_box!=null):
		dialogue_box.queue_free()
		dialogue_box = null
