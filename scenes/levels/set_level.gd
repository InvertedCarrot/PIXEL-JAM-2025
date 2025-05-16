extends Node2D

func _ready():
	var player_node: Node2D = %Player
	var player = player_node.get_child(0)
	player.turn_into_player()
	player.position = Vector2(0, 0)
