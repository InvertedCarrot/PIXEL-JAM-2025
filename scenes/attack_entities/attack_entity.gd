class_name AttackEntity
extends CharacterBody2D

# timers
@onready var uptime_timer: Timer = $UptimeTimer
@onready var hitbox_shape = $AttackHitbox/CollisionShape2D

# abstract properties
var attack_entity_name: String
var speed: float
var can_bounce = null
# uptime is also abstract
var remove_upon_hit = null
var uptime_autostart = null

# regular properties
var decceleration: float
# attack entity data
var attack_entity_data: Dictionary
# used to check if direction, position, from_player were initialized upon adding a PackedScene (i.e. inside the entity's code)
var start_global_position = null
var start_direction = null
var from_player = null


func set_properties() -> void:
	if (!attack_entity_name):
		assert(false, "Define attack_entity_name before calling set_properties()")
	attack_entity_data = Globals.ATTACK_ENTITIES_DATA[attack_entity_name]
	# Set properties from globals
	speed = attack_entity_data["speed"]
	decceleration = attack_entity_data["decceleration"]
	can_bounce = attack_entity_data["can_bounce"]
	uptime_autostart = attack_entity_data["uptime_autostart"]
	remove_upon_hit = attack_entity_data["remove_upon_hit"]
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
	if (!attack_entity_data.has("remove_upon_hit")):
		assert(false, "Error: remove_upon_hit must be defined")
	if (!attack_entity_data.has("uptime_autostart")):
		assert(false, "Error: uptime_autostart must be defined")
	# for PackedScene initialization
	if (start_global_position == null):
		assert(false, "Error: start_global_position must be initialized when adding a PackedScene")
	if (start_direction == null):
		assert(false, "Error: start_direction must be initialized when adding a PackedScene")
	if (from_player == null):
		assert(false, "Error: from_player must be initialized when adding a PackedScene")

func set_layers():
	var hitbox_node = get_node("AttackHitbox")
	# attack entities should not keep track of anything, they should just despawn on their own
	hitbox_node.collision_mask = Globals.NO_LAYER
	# meanwhile, the player hurtbox should keep track of enemy projectiles (and vice versa)
	if from_player:
		hitbox_node.collision_layer = Globals.ATTACK_LAYER
		if remove_upon_hit:
			hitbox_node.collision_mask += Globals.ENEMY_LAYER # look for enemies to hit (and thus remove)
	else:
		hitbox_node.collision_layer = Globals.ENEMY_LAYER
		if remove_upon_hit:
			hitbox_node.collision_mask += Globals.PLAYER_LAYER # same thing


func _ready() -> void:
	set_properties()
	abstract_properties_checks()
	if uptime_autostart:
		uptime_timer.start()
	
	global_position = start_global_position
	velocity = speed * start_direction
	
	set_layers()

func _process(delta: float) -> void:
	# get velocity and deccelerate
	velocity = velocity.normalized() * max(0, velocity.length() - decceleration*delta)
	move_and_slide()

func _on_uptime_timer_timeout() -> void:
	destroy()

func destroy() -> void:
	var tween = get_tree().create_tween()
	hitbox_shape.set_deferred("disabled", true)
	tween.tween_property($EntityImage, "modulate:a", 0.0, 1)
	await tween.finished
	queue_free()

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if remove_upon_hit:
		destroy()
