extends CanvasLayer

var boss_healthbar_node
var boss_health = null
var max_boss_health = null

func _ready() -> void:
	boss_healthbar_node = %BossHealthBar

func _process(_delta: float) -> void:
	if (boss_health != null) && (max_boss_health != null):
		var percent = boss_health/max_boss_health * 100 # need to do this for FP stuff
		boss_healthbar_node.value = percent
		boss_healthbar_node.add_theme_stylebox_override("fill", get_colored_style(Color8(227, 47, 34))) # Red

func update(boss_health_arg, max_boss_health_arg):
	boss_health = boss_health_arg
	max_boss_health = max_boss_health_arg
	

func get_colored_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style
