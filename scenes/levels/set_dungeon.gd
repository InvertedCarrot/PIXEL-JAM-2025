extends Node2D

var cat_entity: PackedScene = preload("res://scenes/entities/cat/cat.tscn")
var bird_entity: PackedScene = preload("res://scenes/entities/bird/bird.tscn")
var fireball_entity: PackedScene = preload("res://scenes/entities/fireball/fireball.tscn")
var lily_entity: PackedScene = preload("res://scenes/entities/lily/lily.tscn")
var reaper_entity: PackedScene = preload("res://scenes/entities/reaper/reaper.tscn")
var soul_entity: PackedScene = preload("res://scenes/entities/soul/soul.tscn")
var npc_entity: PackedScene = preload("res://scenes/entities/npc_cat/npc_cat.tscn")

@onready var player_node: Node2D = %Player
@onready var enemies_node: Node2D = %Enemies
@onready var dead_enemies_node: Node2D = %DeadEnemies
@onready var attack_entities_node: Node2D = %AttackEntities

var camera: Camera2D = Camera2D.new()

@export var spawn_npc: bool = false
@export var npc_position: Vector2 = Vector2.ZERO

var entity_scenes = {
	"bird": bird_entity,
	"cat": cat_entity,
	"fireball": fireball_entity,
	"lily": lily_entity,
	"reaper": reaper_entity,
	"soul": soul_entity
}



func _ready():
	var zoom_factor = 0.5
	camera.zoom = Vector2(zoom_factor, zoom_factor)
	# add the player
	add_entity_to_level(entity_scenes[Globals.player_entity], Vector2(0,0), true)
	# add the npc
	if (spawn_npc):
		add_entity_to_level(npc_entity, npc_position)
	
	
	
	for room in %Rooms.get_children():
		snap_room_to_tile(room)
		
		# only THEN do enemies spawn in
		spawn_enemies_in_room(room)


func snap_room_to_tile(room):
	# get the room's global position and find which tile (i.e. 60 x 60 square) it lies in
	var room_pos_as_tile = room.global_position / 60.0
	room_pos_as_tile = Vector2(round(room_pos_as_tile.x), round(room_pos_as_tile.y))
	# round this position to the nearest integer point
	room.global_position = room_pos_as_tile * 60

func spawn_enemies_in_room(room, enemy_dict = null):
	var spawn_pos_markers = room.get_spawn_positions().map(func(marker_node): return marker_node.global_position)
	var enemies_to_spawn: Dictionary
	if enemy_dict == null:
		enemies_to_spawn = room.get_enemies_to_spawn()
	else:
		enemies_to_spawn = enemy_dict
		
	print("What enemies to spawn: ", enemies_to_spawn)
	
	if spawn_pos_markers.size() > 0:
		for enemy_type in enemies_to_spawn:
			for i in range(enemies_to_spawn[enemy_type]):
				var enemy_spawn_location = spawn_pos_markers.pick_random()
				add_entity_to_level(entity_scenes[enemy_type], enemy_spawn_location)



func _process(delta: float):
	var player = player_node.get_child(0)
	var closest_target = find_closest_dead_enemy() # get the closest dead_enemy to the player (if possible)
	
	if player.is_dead:
		# we should eject the soul out forcefully
		eject_soul(true)
	elif player.swap_souls:
		if player.entity_name != "soul":
			# if currently an entity, eject soul (and keep the body)
			eject_soul(false)
		else:
			# if currently the soul, we want to possess the closest enemy
			if closest_target:
				take_over(closest_target)
			else:
				player.swap_souls = false # if no bodies nearby, deny the swap
	
	for enemy in enemies_node.get_children():
		if enemy.is_dead:
			move_entity_to_dead(enemy)
	
	#modify colours
	for entity in player_node.get_children() + enemies_node.get_children():
		if !entity.immune_timer.is_stopped():
			entity.modulate = Color(1.7, 1, 1, 1)
		else:
			entity.modulate = Color(1, 1, 1, 1)
		
		for dead_enemy in dead_enemies_node.get_children():
			# for dead enemies, we change colour for two cases:
			# 1. if the player is a soul, we possess the closest enemy (i.e. highlight a single enemy)
			# 2. if the player is not a soul, we harvest the souls of all enemies (i.e. highlight them all)
			
			if dead_enemy == closest_target && player.entity_name == "soul":
				dead_enemy.modulate = Color(1.7, 1.7, 1, 1)
			elif dead_enemy in player.dead_entities_in_range && player.entity_name != "soul":
				dead_enemy.modulate = Color(1.1, 1.1, 1.1, 1)
			else:
				dead_enemy.modulate = Color(0.7, 0.7, 0.7, 1)


func add_entity_to_level(entity_packed_scene: PackedScene, spawn_location: Vector2, entity_is_player: bool = false):
	var entity = entity_packed_scene.instantiate()
	entity.player_node = player_node # set this for enemies to track the player
	entity.enemies_node = enemies_node
	entity.dead_enemies_node = dead_enemies_node
	entity.attack_entities_node = attack_entities_node # need to know where to add attack_entities to
	var node_adding_to: Node2D = player_node if entity_is_player else enemies_node
	# raise error if the Player node already has one player
	if entity_is_player:
		if player_node.get_children().size() >= 1:
			assert(false, "Error: There is already a player assigned to the Player node")
	print("DEBUG:", node_adding_to)
	node_adding_to.add_child(entity) # adding node to tree will automatically call the _ready() function
	entity.global_position = spawn_location
	
	if entity_is_player: # trying to add player
		entity.turn_into_player()
		entity.add_child(camera) # attach camera to the player
	else: # trying to add enemy
		node_adding_to = enemies_node
		entity.turn_into_enemy()
	
	return entity


func move_entity_to_dead(entity: CharacterBody2D, entity_is_player: bool = false):
	# move enemy from Enemies node to DeadEnemies node
	if entity_is_player:
		player_node.remove_child(entity)
	else:
		enemies_node.remove_child(entity)
	
	dead_enemies_node.add_child(entity)
	entity.turn_dead()


func eject_soul(eject_forcefully: bool = false):
	var player = player_node.get_child(0)
	var player_velocity = player.velocity
	var eject_location: Vector2 = player.global_position
	player.remove_child(camera)
	if eject_forcefully:
		player_node.remove_child(player) # dispose of the body if ejected forcefully
	else:
		move_entity_to_dead(player, true) # else, move the player body to dead enemies (for re-possession)
	add_entity_to_level(soul_entity, eject_location, true) # replace the player with the soul
	
	# keep momentum/knockback of the previously possessed body
	var new_player = player_node.get_child(0)
	new_player.momentum = player.momentum
	# also, the player should gain some invincibility frames
	new_player.immune_timer.start()

func find_closest_dead_enemy() -> CharacterBody2D:
	# returns null if no dead enemies are within range
	var player = player_node.get_child(0)
	var closest_dead_enemy = null
	var closest_distance = INF
	for dead_enemy in player.dead_entities_in_range:
		var position_diff = player.global_position - dead_enemy.global_position
		var curr_distance = position_diff.length()
		if curr_distance < closest_distance:
			closest_dead_enemy = dead_enemy
			closest_distance = curr_distance
	return closest_dead_enemy

func take_over(target: CharacterBody2D):
	var player = player_node.get_child(0)
	player.remove_child(camera)
	player_node.remove_child(player) # dispose the soul, replace with the enemy
	# "revive" the dead entity (i.e. spawn in a new enemy after deleting the dead one)
	dead_enemies_node.remove_child(target)

	var entity_packed_scene: PackedScene
	match target.entity_name:
		"cat": entity_packed_scene = cat_entity
		"bird": entity_packed_scene = bird_entity
		"fireball": entity_packed_scene = fireball_entity
		"lily": entity_packed_scene = lily_entity
		"reaper": entity_packed_scene = reaper_entity
	var added_entity = add_entity_to_level(entity_packed_scene, target.global_position, true)
	# retain previous health if the target isn't truly dead
	if target.health > 0:
		added_entity.health = target.health
		Globals.player_health = target.health
