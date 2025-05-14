extends Entity


func _ready() -> void:
	detect_zone_ranges = [400, 300, 200, 100]
	is_player = true
	max_speed = 400
	speed = 400
	super()

func _process(delta: float) -> void:
	super(delta)

func idle_behaviour(delta: float) -> void:
	pass

func zone_0_behaviour(delta: float) -> void:
	pass

func zone_1_behaviour(delta: float) -> void:
	pass

func zone_2_behaviour(delta: float) -> void:
	pass

func zone_3_behaviour(delta: float) -> void:
	pass





func _on_area_2d_area_entered(area: Area2D) -> void:
	Globals.health -= 5
