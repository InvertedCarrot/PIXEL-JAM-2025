extends DialogueEngine

var player_name : String # will be set by the UI code

"""
Add all cutscene dialogues here, from entity call dialogue_activate 
with the name of the scene you want to instantiate
"""


func _setup() -> void:
	match Globals.dialogue_scene:
		"intro":
			add_text_entry("Hi ").set_metadata("author", "npc")
			add_text_entry("I was looking for you! Where do you keep wandering off to??").set_metadata("author", "npc")
			add_text_entry("I was chasing a monster, but it's dead now.").set_metadata("author", "you")
			add_text_entry("[i][shake rate=20.0 level=5 connected=1]That skull has nothing to do with it[/shake][/i]").set_metadata("author", "you")
			add_text_entry("I believe you").set_metadata("author","npc")
			add_text_entry("We should go explore the rest of the dungeon! Follow me").set_metadata("author", "npc")
