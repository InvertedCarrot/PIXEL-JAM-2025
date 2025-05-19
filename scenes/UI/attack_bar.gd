extends ProgressBar


@onready var atk_timer: Timer = %AttackTimer
@onready var attackbar_node = %AttackBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackbar_node.value = 100

func _process(_delta: float) -> void:
	var percent = float(atk_timer.wait_time - atk_timer.time_left)/(atk_timer.wait_time) * 100 # need to do this for FP stuff
	attackbar_node.value = percent
	
	if percent >= 100:
		attackbar_node.add_theme_stylebox_override("fill", get_colored_style(Color8(242, 71, 48))) # Red
	else:
		attackbar_node.add_theme_stylebox_override("fill", get_colored_style(Color8(240, 134, 120))) # Faded Red (can't attack yet)

func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
