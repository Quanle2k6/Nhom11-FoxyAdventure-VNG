extends Node

const NORMAL_FOX := "normal_fox"
const AQUA_FOX := "aqua_fox"
const JUNGLE_FOX := "jungle_fox"

var selected_player_scene: PackedScene
var selected_player_key: String = NORMAL_FOX
var checkpoint_positions: Dictionary = {}
var unlocked_players: Dictionary = {
	NORMAL_FOX: true,
	AQUA_FOX: false,
	JUNGLE_FOX: false,
}

func save_checkpoint(player_key: String, position: Vector2) -> void:
	checkpoint_positions[player_key] = position

func has_checkpoint(player_key: String) -> bool:
	return checkpoint_positions.has(player_key)

func get_checkpoint(player_key: String) -> Vector2:
	return checkpoint_positions.get(player_key, Vector2.ZERO)

func clear_checkpoint(player_key: String) -> void:
	checkpoint_positions.erase(player_key)

func is_player_unlocked(player_key: String) -> bool:
	return unlocked_players.get(player_key, false)

func unlock_player(player_key: String) -> void:
	unlocked_players[player_key] = true

func unlock_next_player_after_boss() -> void:
	match selected_player_key:
		NORMAL_FOX:
			unlock_player(AQUA_FOX)
		AQUA_FOX:
			unlock_player(JUNGLE_FOX)
