extends CanvasLayer

@onready var entity = get_tree().get_nodes_in_group("Entity")[0]

var dialogue_box: DialogueBox = null
const dialogue_box_scene = preload("res://scenes/UI/dialogue/dialogue_box.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	entity.connect("dialogue_activate", start)
	$DialogueBox.queue_free()


func start(scene: String):
	print(scene)
	dialogue_box = dialogue_box_scene.instantiate()
	dialogue_box.dialogue_gdscript = load("res://scenes/UI/dialogue/dialogue_log.gd")
	# add dialogue_box as child
	add_child(dialogue_box)
	dialogue_box.begin()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#dialogue_box.visible = Globals.dialogue_active
	if (!Globals.dialogue_active and dialogue_box!=null):
		dialogue_box.queue_free()
