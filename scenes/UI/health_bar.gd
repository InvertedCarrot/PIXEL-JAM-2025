extends ProgressBar

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	var percent = float(Globals.player_health)/(Globals.max_player_health) * 100 # need to do this for FP stuff
	%HealthBar.value = percent
	if percent >= 70:
		%HealthBar.add_theme_stylebox_override("fill", get_colored_style(Color8(60, 161, 2))) # Green
	elif percent >= 30:
		%HealthBar.add_theme_stylebox_override("fill", get_colored_style(Color8(199, 146, 2))) # Yellow
	else:
		%HealthBar.add_theme_stylebox_override("fill", get_colored_style(Color8(255, 105, 36))) # Red


func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
