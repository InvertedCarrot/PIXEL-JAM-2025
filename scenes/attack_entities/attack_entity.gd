class_name AttackEntity
extends CharacterBody2D

# timers
@onready var uptime_timer: Timer = $UptimeTimer

# abstract properties
var attack_entity_name: String
var speed: float
var can_bounce = null
# uptime is also abstract
var uptime_autostart = null

# regular properties
var decceleration: float
# attack entity data
var attack_entity_data: Dictionary
# used to check if direction and position were initialized upon adding a PackedScene (i.e. inside the entity's code)
var start_global_position = null
var start_direction = null

func set_properties() -> void:
	if (!attack_entity_name):
		assert(false, "Define attack_entity_name before calling set_properties()")
	attack_entity_data = Globals.ATTACK_ENTITIES_DATA[attack_entity_name]
	# Set properties from globals
	speed = attack_entity_data["speed"]
	decceleration = attack_entity_data["decceleration"]
	can_bounce = attack_entity_data["can_bounce"]
	uptime_autostart = attack_entity_data["uptime_autostart"]
	uptime_timer.wait_time = attack_entity_data["uptime"]


func abstract_properties_checks() -> void:
	if (!attack_entity_name):
		assert(false, "Error: attack_entity_name must be defined")
	if (!speed):
		assert(false, "Error: speed must be defined")
	if (can_bounce == null):
		assert(false, "Error: can_bounce must be defined")
	if (!attack_entity_data.has("uptime")):
		assert(false, "Error: uptime must be defined")
	if (!attack_entity_data.has("uptime_autostart")):
		assert(false, "Error: uptime_autostart must be defined")
	# for PackedScene initialization
	if (start_global_position == null):
		assert(false, "Error: start_global_position must be initialized when adding a PackedScene")
	if (start_direction == null):
		assert(false, "Error: start_direction must be initialized when adding a PackedScene")



func _ready() -> void:
	set_properties()
	abstract_properties_checks()
	if uptime_autostart:
		uptime_timer.start()
	
	global_position = start_global_position
	velocity = speed * start_direction

func _process(delta: float) -> void:
	# get velocity and deccelerate
	velocity = velocity.normalized() * max(0, velocity.length() - decceleration*delta)
	move_and_slide()

func _on_uptime_timer_timeout() -> void:
	destroy()

func destroy() -> void:
	assert(false, "Error: destroy() must be defined")
