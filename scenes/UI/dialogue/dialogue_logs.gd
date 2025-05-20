extends DialogueEngine

var player_name : String # will be set by the UI code

"""
Add all cutscene dialogues here, from entity call dialogue_activate 
with the name of the scene you want to instantiate
"""


func _setup() -> void:
	match Globals.dialogue_scene:
		"intro":
			add_text_entry("Hey!!!").set_metadata("author", "npc")
			add_text_entry("What are you spacing out for?? We're finally at the entrance!").set_metadata("author", "npc")
			add_text_entry("I was chasing a monster, but it's dead now.").set_metadata("author", Globals.player_entity)
			add_text_entry("[i][shake rate=20.0 level=5 connected=1]This skull has nothing to do with it, I swear[/shake][/i]").set_metadata("author", Globals.player_entity)
			add_text_entry("Sure.....").set_metadata("author","npc")
			add_text_entry("Well anyways, we came here to explore the dungeon, didn't we?").set_metadata("author", "npc")
			add_text_entry("So let's go! C'mon, follow me").set_metadata("author", "npc")
		"first_fight":
			add_text_entry("Hey, do you see that weird-looking bird over there?").set_metadata("author", "npc")
			add_text_entry("HOW MANY TIMES HAVE WE TOLD YOU OUTSIDERS NOT TO TRESPASS??").set_metadata("author", "bird")
			add_text_entry("So mad..... they really need to host some anger management classes in here.").set_metadata("author", "npc")
			add_text_entry("GET OUTTA HERE!").set_metadata("author", "bird")
			add_text_entry("Man, I suck at first impressions. The bird seems to hate me already, so I'll let you take the lead!").set_metadata("author", "npc")
			add_text_entry("You remember what we went over, right? Press <Space> or <F> to scratch them!").set_metadata("author", "npc")
			add_text_entry("I dunno, my memory's a little fuzzy right now.").set_metadata("author", Globals.player_entity)
			add_text_entry("Don't worry, you got this :3").set_metadata("author", "npc")
		"bird_dead":
			add_text_entry("Wow, you really showed them who's boss. Good job!").set_metadata("author", "npc")
			add_text_entry("Thanks I guess? They kept running away from me, though.").set_metadata("author", Globals.player_entity)
			add_text_entry("They must be scared of you. With this, we'll be able to clear the dungeon in no time!").set_metadata("author", "npc")
			add_text_entry("Let's go on, I see an exit over there.").set_metadata("author", "npc")
		"kill_player0":
			add_text_entry("Ooooh another bird!").set_metadata("author", "npc")
			add_text_entry("Wait-").set_metadata("author", Globals.player_entity)
			add_text_entry("Just you wait, I'm gonna get you like my sibling just did!").set_metadata("author", "npc")
			add_text_entry("O_O (did they just kill my cousin??)").set_metadata("author", "bird")
		"kill_player1":
			add_text_entry("... I got left behind").set_metadata("author", Globals.player_entity)
			add_text_entry("Do I smell a [i][shake rate=20.0 level=5 connected=1]soul[/shake][/i] to harvest?").set_metadata("author", "reaper")
			add_text_entry("Aaaaaaah!!!").set_metadata("author", Globals.player_entity)
		"player_dead":
			add_text_entry("OWIE").set_metadata("author", Globals.player_entity)
			add_text_entry("Easy peasy, there's no one to stop me now from possessing this body!").set_metadata("author", "reaper")
			add_text_entry("Hey! What are you doing?").set_metadata("author", Globals.player_entity)
		"evil_soul_possess":
			add_text_entry("Your sibling will have no idea it's me! Hehehehe I'm so evil...").set_metadata("author", "evil_soul")
			add_text_entry("You're not gonna get away with this!").set_metadata("author", Globals.player_entity)
		"level2_start":
			add_text_entry("Welp, I gotta go reunite with my [i][shake rate=20.0 level=5 connected=1]beloved sibling[/shake][/i]. See ya, sucker :P").set_metadata("author", "cat")
			add_text_entry("NO").set_metadata("author", Globals.player_entity)
		"possessing_tutorial":
			add_text_entry("Drats. I have to save my sibling from that possessive freak!").set_metadata("author", Globals.player_entity)
			add_text_entry("If only I weren't so weak as a soul...").set_metadata("author", Globals.player_entity)
			add_text_entry("...Wait!").set_metadata("author", Globals.player_entity)
			add_text_entry("If that [i][shake rate=20.0 level=5 connected=1]thing[/shake][/i] could possess my dead body, maybe I could do the same?").set_metadata("author", Globals.player_entity)
			add_text_entry("Let's see if I can find any dead guys to possess.").set_metadata("author", Globals.player_entity)
			add_text_entry("I think I can do it with <C>? Man, my beginner's guide to dungeon exploring was unclear about this.").set_metadata("author", Globals.player_entity)
		"possessed_tutorial":
			add_text_entry("Wow, so that does work!").set_metadata("author", Globals.player_entity)
			add_text_entry("If I remember correctly, I can also eject my soul with <C> as well.").set_metadata("author", Globals.player_entity)
			add_text_entry("Oh! Wasn't the chapter about \"soul harvesting\" really important too?").set_metadata("author", Globals.player_entity)
			add_text_entry("I think pressing <V> lets me harvest the dead and powers me up for tougher enemies? Something like that.").set_metadata("author", Globals.player_entity)
			add_text_entry("I think that's only possible if I'm possessing a body, right? I really should've payed attention in class").set_metadata("author", Globals.player_entity)
			add_text_entry("...").set_metadata("author", Globals.player_entity)
			add_text_entry("Get it together, dude. You gotta save your sibling!").set_metadata("author", Globals.player_entity)
		"final_boss_intro":
			add_text_entry("...so as I was saying-").set_metadata("author", "npc")
			add_text_entry("HEY! I FOUND YOU").set_metadata("author", Globals.player_entity)
			add_text_entry("Oho! So we meet again.").set_metadata("author", "cat")
			add_text_entry("Hey, what's the matter? You've been acting strange for a while.").set_metadata("author", "npc")
			add_text_entry("Oh nothing of significance, sibling. Let me pulverize this [i][shake rate=20.0 level=5 connected=1]pesky vermin[/shake][/i]").set_metadata("author", "cat")
			add_text_entry("Ok then...?").set_metadata("author", "npc")
			add_text_entry("Don't fall for it! That isn't me, I'm me!").set_metadata("author", Globals.player_entity)
			add_text_entry("Psssh, just a typical dungeon scallywag baiting you to drop your guard. Pay no attention to it.").set_metadata("author", "cat")
			add_text_entry("Give me my body back!").set_metadata("author", Globals.player_entity)
			add_text_entry("Ha! I'd like to see you try.").set_metadata("author", "cat")
			add_text_entry("(What is going on???)").set_metadata("author", "npc")
		"game_over":
			add_text_entry("WHAT").set_metadata("author", "evil_soul")
			add_text_entry("[i][shake rate=20.0 level=5 connected=1]You... how did you do that?[/shake][/i]").set_metadata("author", "evil_soul")
			add_text_entry("You're not the only one whose soul is strong, y'know?").set_metadata("author", Globals.player_entity)
			add_text_entry("That's preposterous! How could the likes of you stand against a powerful being such as me-").set_metadata("author", "evil_soul")
			add_text_entry("Bro... is that you?").set_metadata("author", "npc")
			add_text_entry(":D It's me!!!").set_metadata("author", Globals.player_entity)
			add_text_entry("Excuse me! I'm in the middle of monologuing here-").set_metadata("author", "evil_soul")
			add_text_entry("Bro!").set_metadata("author", "npc")
			add_text_entry("Bro!!").set_metadata("author", Globals.player_entity)
			add_text_entry("BRO!!!").set_metadata("author", "npc")
			add_text_entry("BRO!!!!!").set_metadata("author", Globals.player_entity)
			add_text_entry("... whatever. I'm too old for this.").set_metadata("author", "evil_soul")
