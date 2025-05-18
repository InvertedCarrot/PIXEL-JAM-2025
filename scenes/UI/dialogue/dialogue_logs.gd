extends DialogueEngine

var player_name : String # will be set by the UI code

"""
Add all cutscene dialogues here, from entity call dialogue_activate 
with the name of the scene you want to instantiate
"""


func _setup() -> void:
	match Globals.dialogue_scene:
		"start":		
			add_text_entry("Hey...").set_metadata("author", "npc")
			add_text_entry("We should enter this dungeon. The skull gave me a good feeling about this!").set_metadata("author","npc")
			add_text_entry("It's so [i][shake rate=20.0 level=5 connected=1]spoooky[/shake][/i]").set_metadata("author", "npc")
		"second":
			add_text_entry("Hey... this is a second time").set_metadata("author", "npc")
			add_text_entry("Did you get memory loss?").set_metadata("author","npc")
			add_text_entry("Seems like it...").set_metadata("author", "npc")
