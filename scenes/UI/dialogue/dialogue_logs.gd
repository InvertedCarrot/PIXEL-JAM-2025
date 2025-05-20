extends DialogueEngine

var player_name : String # will be set by the UI code

"""
Add all cutscene dialogues here, from entity call dialogue_activate 
with the name of the scene you want to instantiate
"""


func _setup() -> void:
	match Globals.dialogue_scene:
		"intro":
			add_text_entry("Hey!!! ").set_metadata("author", "npc")
			add_text_entry("I was looking for you! Where do you keep wandering off to??").set_metadata("author", "npc")
			add_text_entry("I was chasing a monster, but it's dead now.").set_metadata("author", Globals.player_entity)
			add_text_entry("[i][shake rate=20.0 level=5 connected=1]That skull has nothing to do with
			 it[/shake][/i]").set_metadata("author", Globals.player_entity)
			add_text_entry("Yeah right").set_metadata("author","npc")
			add_text_entry("We should go explore the rest of the dungeon! Follow me").set_metadata("author", "npc")
		"first_fight":
			add_text_entry("Oh it's the witch-craft bird...").set_metadata("author", "npc")
			add_text_entry("HOW MANY TIMES HAVE WE TOLD YOU SIBLINGS NOT TO TRY TO ENTER OUR CAVE?").set_metadata("author", "bird")
			add_text_entry("They look mad at us...").set_metadata("author", "npc")
			add_text_entry("You remember how to fight them right? Press <Space> to scratch them!").set_metadata("author", "npc")
			add_text_entry("And try to dodge their potions!").set_metadata("author", "npc")
		"bird_dead":
			add_text_entry("Hey you killed it. Good job!").set_metadata("author", "npc")
			add_text_entry("They run away a lot!").set_metadata("author", Globals.player_entity)
			add_text_entry("Let's get out of here to the next dungeon...").set_metadata("author", "npc")
		"kill_player0":
			add_text_entry("Oh look, now there's a bird and a grim reaper").set_metadata("author", "npc")
			add_text_entry("I'll take the bird, you look after the reaper!").set_metadata("author", "npc")
		"kill_player1":
			add_text_entry("I will take your soul as you've come to know it!").set_metadata("author", "reaper")
			add_text_entry("Try me!").set_metadata("author", Globals.player_entity)
		"player_dead":
			add_text_entry("I will now take over your body! Say goodbye to it!").set_metadata("author", "reaper")
		"evil_soul_possess":
			add_text_entry("Your sibling will have no idea it's me!").set_metadata("author", "evil_soul")
			add_text_entry("You will not get away with this!").set_metadata("author", Globals.player_entity)
		"level2_start":
			add_text_entry("Haha! I'm running away!").set_metadata("author", "cat")
		"possessing_tutorial":
			add_text_entry("If I remember correctly").set_metadata("author", Globals.player_entity)
			add_text_entry("The way to possess dead enemies is <C>").set_metadata("author", Globals.player_entity)
		"possessed_tutorial":
			add_text_entry("I believe I can leave my body with <C> as well!").set_metadata("author", Globals.player_entity)
			add_text_entry("I can also harvest souls with <V>, that gives me boost ups!").set_metadata("author", Globals.player_entity)
		"final_boss_intro":
			add_text_entry("So we meet again!").set_metadata("author", "cat")
			add_text_entry("What made you so aggressive?").set_metadata("author", "npc")
			add_text_entry("You must fight me to win your body back!").set_metadata("author", "cat")
			add_text_entry("You will not win!").set_metadata("author", Globals.player_entity)
		"game_over":
			add_text_entry("Fine! Whatever, I'm done with you anyway").set_metadata("author", "evil_soul")
