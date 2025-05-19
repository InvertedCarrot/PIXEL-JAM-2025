extends VBoxContainer

var player_portraits = {
	"bird": load("res://assets/portraits/bird_portrait.png"),
	"cat": load("res://assets/portraits/cat_portrait.png"),
	"fireball": load("res://assets/portraits/fireball_portrait.png"),
	"lily": load("res://assets/portraits/lily_portrait.png"),
	"reaper": load("res://assets/portraits/reaper_portrait.png"),
	"soul": load("res://assets/portraits/soul_portrait.png"),
}

var player_portrait_outlines = {
	"bird": Color("#3d3d3d"),
	"cat": Color("#bd810e"),
	"fireball": Color("#aa20ff"),
	"lily": Color("#266700"),
	"reaper": Color("#00376e"),
	"soul": Color("#a6e7ff"),
}

var player_portrait_backgrounds = {
	"bird": Color("#b2b2b2"),
	"cat": Color("#fce9c7"),
	"fireball": Color("#8101c5"),
	"lily": Color("#ffd3ef"),
	"reaper": Color("#6d8bbf"),
	"soul": Color("#6d9aab"),
}


@onready var outline_panel = %PlayerPortraitOutline.get("theme_override_styles/panel") as StyleBoxFlat
@onready var background_panel = %PlayerPortraitBackground.get("theme_override_styles/panel") as StyleBoxFlat

func _ready():
	pass

func _process(_delta) -> void:
	# set portrait to whatever entity the player currently is
	%PlayerPortrait.texture = player_portraits[Globals.player_entity]
	outline_panel.bg_color = player_portrait_outlines[Globals.player_entity]
	background_panel.bg_color = player_portrait_backgrounds[Globals.player_entity]
