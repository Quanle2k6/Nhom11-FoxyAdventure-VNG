extends Node2D

@onready var start_point := $StartPoint

var player: Player

func _ready() -> void:
	player = GameData.selected_player_scene.instantiate()
	add_child(player)
	player.apply_spawn(start_point.global_position)
