extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var percent = float(Globals.souls_harvested)/(Globals.SOUL_CAPACITY) * 100 # need to do this for FP stuff
	%MulitplierBar.value = percent
	%MultiplierLabel.text = str(Globals.souls_harvested)
	if percent >= 70:
		%MulitplierBar.add_theme_stylebox_override("fill", get_colored_style(Color8(255, 244, 0))) # Yellow
	elif percent >= 30:
		%MulitplierBar.add_theme_stylebox_override("fill", get_colored_style(Color8(255, 72, 0))) # Orange
	else:
		%MulitplierBar.add_theme_stylebox_override("fill", get_colored_style(Color8(255, 105, 0))) # Red

func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
