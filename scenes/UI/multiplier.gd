extends ProgressBar

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	var percent = float(Globals.souls_harvested)/(Globals.SOUL_CAPACITY) * 100 # need to do this for FP stuff
	%MultiplierBar.value = percent
	if percent >= 70:
		%MultiplierBar.add_theme_stylebox_override("fill", get_colored_style(Color8(255, 244, 0))) # Yellow
	elif percent >= 30:
		%MultiplierBar.add_theme_stylebox_override("fill", get_colored_style(Color8(255, 72, 0))) # Orange
	else:
		%MultiplierBar.add_theme_stylebox_override("fill", get_colored_style(Color8(255, 105, 0))) # Red

func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
