extends Node

const NORMAL_FOX := "normal_fox"
const AQUA_FOX := "aqua_fox"
const JUNGLE_FOX := "jungle_fox"

var selected_player_scene: PackedScene
var selected_player_key: String = NORMAL_FOX
var checkpoint_positions: Dictionary = {}

func save_checkpoint(player_key: String, position: Vector2) -> void:
	checkpoint_positions[player_key] = position

func has_checkpoint(player_key: String) -> bool:
	return checkpoint_positions.has(player_key)

func get_checkpoint(player_key: String) -> Vector2:
	return checkpoint_positions.get(player_key, Vector2.ZERO)

func clear_checkpoint(player_key: String) -> void:
	checkpoint_positions.erase(player_key)
