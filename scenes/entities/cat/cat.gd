extends Entity


func _ready() -> void:
	set_properties("cat")
	is_player = true
	super()

func _process(delta: float) -> void:
	super(delta)

func idle_behaviour() -> void:
	pass

func zone_0_behaviour() -> void:
	pass

func zone_1_behaviour() -> void:
	pass

func zone_2_behaviour() -> void:
	pass

func zone_3_behaviour() -> void:
	pass

func attack() -> void:
	pass



func _on_area_2d_area_entered(area: Area2D) -> void:
	Globals.health -= 5
