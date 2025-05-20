extends VBoxContainer



@onready var outline_panel = %PlayerPortraitOutline.get("theme_override_styles/panel") as StyleBoxFlat
@onready var background_panel = %PlayerPortraitBackground.get("theme_override_styles/panel") as StyleBoxFlat

@export_enum ("PlayerStats", "Speaker")
var portrait_type:String
## Player type => on top-left
## Speaker type => with dialogues

func _ready():
	if (!portrait_type):
		assert(false, "Choose a portrait type")
	pass

func _process(_delta) -> void:
	# set portrait to whatever entity the player currently is
	if (portrait_type=="PlayerStats"):
		%PlayerPortrait.texture = Globals.player_portraits[Globals.player_entity]
		outline_panel.bg_color = Globals.player_portrait_outlines[Globals.player_entity]
		background_panel.bg_color = Globals.player_portrait_backgrounds[Globals.player_entity]
	elif (portrait_type=="Speaker"):
		%PlayerPortrait.texture = Globals.player_portraits[Globals.current_speaker]
		outline_panel.bg_color = Globals.player_portrait_outlines[Globals.current_speaker]
		background_panel.bg_color = Globals.player_portrait_backgrounds[Globals.current_speaker]
