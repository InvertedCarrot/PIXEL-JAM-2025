extends DialogueEngine

var player_name : String # will be set by the UI code

func _setup() -> void:
	add_text_entry("Hey...").set_metadata("author", "npc")
	add_text_entry("We should enter this dungeon. The skull gave me a good feeling about this!").set_metadata("author","npc")
	add_text_entry("It's so [i][shake rate=20.0 level=5 connected=1]spoooky[/shake][/i]").set_metadata("author", "npc")
