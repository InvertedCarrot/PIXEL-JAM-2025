class_name AttackEntity
extends CharacterBody2D

# timers
@onready var uptime_timer: Timer = $UptimeTimer
@onready var hitbox_shape = $AttackHitbox/CollisionShape2D

# abstract properties
var attack_entity_name: String
var damage: float
var speed: float
var decceleration: float
var knockback_scalar: float
# uptime is also abstract

var remove_upon_hit: bool
var uptime_autostart: bool
var can_bounce: bool


# attack entity data
var attack_entity_data: Dictionary
# used to check if direction, position, from_player were initialized upon adding a PackedScene (i.e. inside the entity's code)
var start_global_position = null
var start_direction = null
var from_player = null


func check_array_property_exists(property_name: String, array_length: int = 2):
	if (!attack_entity_data.has(property_name)):
		assert(false, "Error: " + property_name + " must be defined")
	if (attack_entity_data[property_name].size() != array_length):
		assert(false, "Error: " + property_name + " must be an array of size " + str(array_length))

func check_bool_property_exists(property_name):
	if (!attack_entity_data[property_name] in [true, false]):
		assert(false, "Error: " + property_name + " must be defined")


func set_properties() -> void:
	if (!attack_entity_name):
		assert(false, "Define attack_entity_name before calling set_properties()")
	# Set properties from globals
	damage = attack_entity_data["damage"][0]
	speed = attack_entity_data["speed"][0]
	decceleration = attack_entity_data["decceleration"][0]
	knockback_scalar = attack_entity_data["knockback_scalar"][0]
	uptime_timer.wait_time = attack_entity_data["uptime"][0]
	remove_upon_hit = attack_entity_data["remove_upon_hit"]
	uptime_autostart = attack_entity_data["uptime_autostart"]
	can_bounce = attack_entity_data["can_bounce"]



func abstract_properties_checks() -> void:
	if (!attack_entity_name):
		assert(false, "Error: attack_entity_name must be defined")
	attack_entity_data = Globals.ATTACK_ENTITIES_DATA[attack_entity_name]
	check_array_property_exists("damage")
	check_array_property_exists("speed")
	check_array_property_exists("decceleration")
	check_array_property_exists("knockback_scalar")
	check_array_property_exists("uptime")
	check_bool_property_exists("remove_upon_hit")
	check_bool_property_exists("uptime_autostart")
	check_bool_property_exists("can_bounce")
	# for PackedScene initialization
	if (start_global_position == null):
		assert(false, "Error: start_global_position must be initialized when adding a PackedScene")
	if (start_direction == null):
		assert(false, "Error: start_direction must be initialized when adding a PackedScene")
	if (from_player == null):
		assert(false, "Error: from_player must be initialized when adding a PackedScene")



func scale_attack_entity_stats():
	damage = scale_property("damage")
	speed = scale_property("speed")
	decceleration = scale_property("decceleration")
	knockback_scalar = scale_property("knockback_scalar")
	uptime_timer.wait_time = scale_property("uptime")

func scale_property(property_name: String):
	var damage_scale_value: float
	if from_player:
		damage_scale_value = Globals.souls_harvested/Globals.SOUL_CAPACITY
	else:
		damage_scale_value = Globals.enemy_damage_scale
	var base_value = attack_entity_data[property_name][0]
	var top_value = attack_entity_data[property_name][1]
	var new_value = base_value + (top_value - base_value) * Globals.damage_scale_function(damage_scale_value)
	return new_value

func set_layers():
	var hitbox_node = get_node("AttackHitbox")
	# the player hurtbox should keep track of enemy projectiles (and vice versa)
	if from_player:
		hitbox_node.collision_layer = Globals.PLAYER_ATTACK_LAYER
		if remove_upon_hit:
			hitbox_node.collision_mask = Globals.ENEMY_LAYER # look for enemies to hit (and thus remove)
	else:
		hitbox_node.collision_layer = Globals.ENEMY_ATTACK_LAYER
		if remove_upon_hit:
			hitbox_node.collision_mask = Globals.PLAYER_LAYER # same thing
	
	# wall collision shapes should not see anything but the wall
	collision_layer = Globals.NO_LAYER
	if can_bounce:
		collision_mask = Globals.WALL_LAYER
	else:
		collision_mask = Globals.NO_LAYER





func _ready() -> void:
	abstract_properties_checks()
	set_properties()
	if uptime_autostart:
		uptime_timer.start()
	set_layers()
	scale_attack_entity_stats()
	global_position = start_global_position
	velocity = speed * start_direction


func _process(delta: float) -> void:
	# get velocity and deccelerate
	velocity = velocity.normalized() * max(0, velocity.length() - decceleration*delta)
	reflect_velocity(delta)

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


func reflect_velocity(delta) -> void:
	# function for reflecting an enemy's movement
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
