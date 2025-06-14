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

var player_portraits = {
	"bird": load("res://assets/portraits/bird_portrait.png"),
	"cat": load("res://assets/portraits/cat_portrait.png"),
	"fireball": load("res://assets/portraits/fireball_portrait.png"),
	"lily": load("res://assets/portraits/lily_portrait.png"),
	"reaper": load("res://assets/portraits/reaper_portrait.png"),
	"soul": load("res://assets/portraits/soul_portrait.png"),
}

func _ready() -> void:
	$DialogueBox.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!Globals.dialogue_active and dialogue_box!=null):
		dialogue_box.queue_free()
		dialogue_box = null
	
	%PlayerPortrait.texture = player_portraits[Globals.player_entity]


func start(scene: String, start_speaker: String):
	if (dialogue_box==null):
		Globals.current_speaker = start_speaker
		Globals.dialogue_active = true
		Globals.dialogue_scene = scene
		Globals.dialogue_stages[scene] = Globals.IN_PROGRESS
		dialogue_box = Globals.DIALOGUE_BOX_SCENE.instantiate()
		dialogue_box.dialogue_gdscript = Globals.CUTSCENES_GDSCRIPT
		# add dialogue_box as child
		add_child(dialogue_box)
		dialogue_box.begin()

func make_boss_healthbar_visible():
	%BossHealthBar.visible = true

func update_boss_healthbar(boss_ref, max_boss_health):
	%BossHealthBar.update(boss_ref.health, max_boss_health)

# Attack timer updates
func attack():
	%AttackBar.atk_timer.start()

func update_attack_timer(time: float):
	%AttackBar.atk_timer.wait_time = time

func reset_timer():
	%AttackBar.atk_timer.stop()

## Connect any newly entering entity to signal
func safe_connect(entity: Node):
	if entity.is_in_group("Entity"):
		if not entity.is_connected("dialogue_activate", start):
			entity.connect("dialogue_activate", start)
			entity.connect("attack_started", attack)
			entity.connect("update_attack_timer", update_attack_timer)
			entity.connect("reset_timer", reset_timer)

func _on_player_child_entered_tree(node: Node) -> void:
	safe_connect(node)

func _on_enemies_child_entered_tree(node: Node) -> void:
	safe_connect(node)
