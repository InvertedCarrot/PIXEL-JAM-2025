extends ProgressBar

var healthbar_node

func _ready() -> void:
	healthbar_node = %HealthBar

func _process(_delta: float) -> void:
	var percent = float(Globals.player_health)/(Globals.max_player_health) * 100 # need to do this for FP stuff
	healthbar_node.value = percent
	if percent >= 60:
		healthbar_node.add_theme_stylebox_override("fill", get_colored_style(Color8(47, 173, 72))) # Green
	elif percent >= 30:
		healthbar_node.add_theme_stylebox_override("fill", get_colored_style(Color8(214, 170, 49))) # Yellow
	elif percent >= 15:
		healthbar_node.add_theme_stylebox_override("fill", get_colored_style(Color8(227, 47, 34))) # Red
	else:
		healthbar_node.add_theme_stylebox_override("fill", get_colored_style(Color8(107, 19, 13))) # Dark Red


func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
