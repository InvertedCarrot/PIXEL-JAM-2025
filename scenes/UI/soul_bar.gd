extends ProgressBar

var white_colour = Color8(255, 255, 255)
var full_soulbar_colour = Color8(61, 219, 214)
var soulbar_node


func _ready() -> void:
	soulbar_node = %SoulBar

func _process(_delta: float) -> void:
	var percent_normalized = float(
	Globals.souls_harvested)/(Globals.SOUL_CAPACITY)
	var percent = percent_normalized * 100 # need to do this for FP stuff
	soulbar_node.value = percent
	
	var fill_colour = (1-percent_normalized)*white_colour + percent_normalized*full_soulbar_colour
	soulbar_node.add_theme_stylebox_override("fill", get_colored_style(fill_colour))


func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
