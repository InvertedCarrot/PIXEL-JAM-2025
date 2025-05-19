extends CanvasLayer

var entities
var is_connected: bool = false

var dialogue_box: DialogueBox = null

"""
Ok this is a but scuffed so I will write down what is going on.
This script only handles stuff for the dialogue, and the logic is:
	1. Some entity emits a dialogue signal (which gets connected to start)
	2. The dialogue_box creates a dialogue box scene on-spot
	3. Sets the gdscript path correctly and passes it onto the actual dialogue
	4. Delete the dialogue box object from tree once dialogue is done 
			(and re-create for each dialogue)
"""

func _ready() -> void:
	$DialogueBox.queue_free()


func start(scene: String):
	if (dialogue_box==null):
		Globals.dialogue_active = true
		Globals.dialogue_scene = scene
		dialogue_box = Globals.DIALOGUE_BOX_SCENE.instantiate()
		dialogue_box.dialogue_gdscript = Globals.CUTSCENES_GDSCRIPT
		# add dialogue_box as child
		add_child(dialogue_box)
		dialogue_box.begin()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!Globals.dialogue_active and dialogue_box!=null):
		dialogue_box.queue_free()
		dialogue_box = null


## Connect any newly entering entity to signal
func safe_connect(entity: Node):
	if entity.is_in_group("Entity"):
		if not entity.is_connected("dialogue_activate", start):
			entity.connect("dialogue_activate", start)

func _on_player_child_entered_tree(node: Node) -> void:
	safe_connect(node)

func _on_enemies_child_entered_tree(node: Node) -> void:
	safe_connect(node)
