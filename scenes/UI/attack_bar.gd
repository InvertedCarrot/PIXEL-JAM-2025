extends ProgressBar

@onready var atk_timer: Timer = %AttackTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AttackBar.value = 100

func _process(_delta: float) -> void:
	var percent = float(atk_timer.wait_time - atk_timer.time_left)/(atk_timer.wait_time) * 100 # need to do this for FP stuff
	%AttackBar.value = percent

func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
