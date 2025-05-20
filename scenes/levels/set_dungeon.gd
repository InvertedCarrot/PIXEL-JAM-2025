extends Node2D

var cat_entity: PackedScene = preload("res://scenes/entities/cat/cat.tscn")
var bird_entity: PackedScene = preload("res://scenes/entities/bird/bird.tscn")
var fireball_entity: PackedScene = preload("res://scenes/entities/fireball/fireball.tscn")
var lily_entity: PackedScene = preload("res://scenes/entities/lily/lily.tscn")
var reaper_entity: PackedScene = preload("res://scenes/entities/reaper/reaper.tscn")
var soul_entity: PackedScene = preload("res://scenes/entities/soul/soul.tscn")
var npc_entity: PackedScene = preload("res://scenes/entities/npc_cat/npc_cat.tscn")
var evil_soul_entity: PackedScene = preload("res://scenes/entities/soul/evil_soul.tscn")
var strong_reaper_entity: PackedScene = preload("res://scenes/entities/reaper/strong_reaper.tscn")

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
	"soul": soul_entity,
	"strong_reaper": strong_reaper_entity
}

var level1_cutscene: bool = false
var level2_cat: bool = false
var level2_deadbird: bool = false
var level5_evil_soul: bool = false
var max_boss_health: float = 0
var boss_ref = null
var set_boss_ref: bool = false

func _ready():
	match Globals.current_dungeon:
		3: Globals.enemy_damage_scale = 0.2
		4: Globals.enemy_damage_scale = 0.7
		5: Globals.enemy_damage_scale = 1
		6: Globals.enemy_damage_scale = 1
		_: Globals.enemy_damage_scale = 0
	
	var zoom_factor = 1.5
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
	
	
	if Globals.current_dungeon == 5:
		$Music.stream = load("res://assets/music/daboss.wav")
	$Music.play()

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
	
	for marker_pos in spawn_pos_markers:
		var decoration: Sprite2D = Sprite2D.new()
		decoration.texture = load("res://assets/" + ["skull", "grave", "cobweb"].pick_random() +".png")
		decoration.global_position = marker_pos + Vector2(randf_range(-100,100), randf_range(-100,100))
		$Decorations.add_child(decoration)

func _process(delta: float):
	if Globals.current_dungeon == 5 :
		if !set_boss_ref:
			for enemy in %Enemies.get_children():
				if enemy.is_in_group("Cat"):
					max_boss_health = enemy.health
					$UI.make_boss_healthbar_visible()
					boss_ref = enemy
					set_boss_ref = true
					break
		else:
			$UI.update_boss_healthbar(boss_ref, max_boss_health)
		
	
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
			entity.modulate = Color(2, 1, 1, 1)
		else:
			entity.modulate = Color(1, 1, 1, 1)
		
		for dead_enemy in dead_enemies_node.get_children():
			# for dead enemies, we change colour for two cases:
			# 1. if the player is a soul, we possess the closest enemy (i.e. highlight a single enemy)
			# 2. if the player is not a soul, we harvest the souls of all enemies (i.e. highlight them all)
			
			if dead_enemy == closest_target && player.entity_name == "soul":
				dead_enemy.modulate = Color(1.8, 1.8, 1, 1)
			elif dead_enemy in player.dead_entities_in_range && player.entity_name != "soul":
				dead_enemy.modulate = Color(1.2, 1.2, 1.2, 1)
			else:
				dead_enemy.modulate = Color(0.7, 0.7, 0.7, 1)
	
	if ($DeadEnemies.get_child_count()==0 and Globals.current_dungeon>=3):
		for room in %Rooms.get_children():
			var spawn_pos_markers = room.get_spawn_positions().map(func(marker_node): return marker_node.global_position)
			add_entity_to_level(entity_scenes[["reaper","lily","bird","fireball"].pick_random()], spawn_pos_markers.pick_random(), false, true)
			
	
	if (Globals.check_dialogue_state("bird_dead",1, Globals.DONE)
			and Globals.check_dialogue_state("kill_player0", 1, Globals.IN_PROGRESS)
			and !level1_cutscene):
		add_entity_to_level(entity_scenes["bird"], $BirdPosition.position)
		add_entity_to_level(entity_scenes["strong_reaper"], $GrimReaperposition.position)
		level1_cutscene = true
		$Music.stream = load("res://assets/music/daboss.wav")
		$Music.play()
	
	if (Globals.check_dialogue_state("kill_player0", 1, Globals.DONE)) and (Globals.check_dialogue_state("kill_player1", 1, Globals.NOT_STARTED)):
		delete_projectiles()
	
	if (Globals.check_dialogue_state("player_dead", 1, Globals.IN_PROGRESS)):
		delete_projectiles()
	
	if (Globals.check_dialogue_state("player_dead",1,Globals.DONE)):
		var reaper = $Enemies.get_child(0)
		reaper.turn_dead()
		add_entity_to_level(evil_soul_entity, reaper.position)
		reaper.dialogue_activate.emit("evil_soul_possess", "evil_soul")
		$Music.stream = load("res://assets/music/dungeon.wav")
		$Music.play()
	
	if (Globals.current_dungeon==2 and !level2_cat):
		add_entity_to_level(cat_entity, Vector2(300,0))
		level2_cat=true

	if (Globals.check_dialogue_state("possessing_tutorial", 2, Globals.IN_PROGRESS) and !level2_deadbird):
		add_entity_to_level(bird_entity, $DeadBirdEnemy.position, false, true)
		level2_deadbird = true
	
	if (Globals.check_dialogue_state("game_over", 5, Globals.IN_PROGRESS) and !level5_evil_soul):
		for enemy in $DeadEnemies.get_children():
			if enemy.is_in_group("Cat"):
				add_entity_to_level(evil_soul_entity, enemy.position + Vector2(50,50))
		level5_evil_soul=true
	
	
	
	
func add_entity_to_level(entity_packed_scene: PackedScene, spawn_location: Vector2, entity_is_player: bool = false, kill_on_spawn: bool = false):
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
	node_adding_to.add_child(entity) # adding node to tree will automatically call the _ready() function
	entity.global_position = spawn_location
	
	if entity_is_player: # trying to add player
		entity.turn_into_player()
		entity.add_child(camera) # attach camera to the player
	else: # trying to add enemy
		node_adding_to = enemies_node
		entity.turn_into_enemy()
	
	if (kill_on_spawn):
		entity.turn_dead()
	
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
		if Globals.check_dialogue_state("kill_player1", 1, Globals.DONE):
			## When the player dies
			move_entity_to_dead(player, true)
			add_entity_to_level(soul_entity, eject_location, true)
			player.dialogue_activate.emit("player_dead", "reaper")
			return
		else:
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

func delete_projectiles():
	for attack_entity in %AttackEntities.get_children():
		attack_entity.destroy()


func _on_music_finished() -> void:
	$Music.play()
