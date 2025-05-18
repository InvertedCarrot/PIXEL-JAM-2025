extends DialogueEngine

var player_name : String # will be set by the UI code

func _setup() -> void:
	add_text_entry("Hey... this is a second time").set_metadata("author", "npc")
	add_text_entry("Did you get memory loss?").set_metadata("author","npc")
	add_text_entry("Seems like it...").set_metadata("author", "npc")
