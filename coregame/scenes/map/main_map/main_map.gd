extends Node2D

@onready var old_player := $Player

var player: Player

func _ready():

	var spawn_pos = old_player.global_position
	var parent = old_player.get_parent()

	# xóa Player placeholder
	old_player.queue_free()

	# tạo Player thật
	player = GameData.selected_player_scene.instantiate()

	parent.add_child(player)
	player.apply_spawn(spawn_pos)
