extends Entity

func _ready() -> void:
	can_control = true
	super()

func _process(delta: float) -> void:
	super(delta)


func _on_area_2d_area_entered(area: Area2D) -> void:
	Globals.health -=5
