extends CanvasLayer

class_name DialogueBox

@export var dialogue_gdscript : GDScript

func begin():
	%Dialogue.dialogue_gdscript = dialogue_gdscript
	%Dialogue.begin()
