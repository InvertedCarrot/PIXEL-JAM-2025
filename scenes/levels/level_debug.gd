extends Node2D

func _ready():
	var player_node: Node2D = %Player
	var player = player_node.get_child(0)
	player.is_player = true
