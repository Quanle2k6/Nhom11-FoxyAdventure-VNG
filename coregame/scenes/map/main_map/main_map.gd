extends Node2D

@onready var old_player := $Player
@onready var start_point := $StartPoint

var player: Player

func _ready() -> void:
	var spawn_pos :Vector2 = start_point.global_position
	var parent := old_player.get_parent()

	old_player.queue_free()

	player = GameData.selected_player_scene.instantiate()
	parent.add_child(player)
	player.apply_spawn(spawn_pos)
