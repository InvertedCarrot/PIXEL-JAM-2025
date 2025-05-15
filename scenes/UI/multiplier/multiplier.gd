extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var percent = float(Globals.multiplier)/(Globals.MAX_MULTIPLIER) * 100 # need to do this for FP stuff
	%MulitplierBar.value = percent
	%MultiplierLabel.text = "x 1." + str(Globals.multiplier)


func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
