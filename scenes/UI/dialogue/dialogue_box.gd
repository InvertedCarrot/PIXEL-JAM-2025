extends CanvasLayer

class_name DialogueBox

@export var dialogue_gdscript : GDScript

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func begin():
	print(dialogue_gdscript)
	%Dialogue.dialogue_gdscript = dialogue_gdscript

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
