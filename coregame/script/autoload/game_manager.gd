extends Node

const NORMAL_FOX := "normal_fox"
const AQUA_FOX := "aqua_fox"
const JUNGLE_FOX := "jungle_fox"

const MAIN_MAP_PATH := "res://scenes/map/main_map/main_map.tscn"
const PICK_PLAYER_PATH := "res://scenes/menu/pick_player.tscn"

var selected_player_scene: PackedScene
var selected_player_key: String = NORMAL_FOX
var current_player: Player = null
var current_stage: Node = null
var checkpoint_ids_by_player: Dictionary = {}
var current_checkpoint_id: String = ""
var unlocked_players: Dictionary = {
	NORMAL_FOX: true,
	AQUA_FOX: false,
	JUNGLE_FOX: false,
}

func _ready() -> void:
	load_checkpoint_data()

func register_player(player: Player) -> void:
	current_player = player

func unregister_player(player: Player) -> void:
	if current_player == player:
		current_player = null

func register_stage(stage: Node) -> void:
	current_stage = stage

func select_player(player_key: String, player_scene: PackedScene) -> void:
	selected_player_key = player_key
	selected_player_scene = player_scene
	current_checkpoint_id = get_checkpoint_id(player_key)

func change_to_main_map() -> void:
	change_to_scene(MAIN_MAP_PATH)

func change_to_pick_player() -> void:
	change_to_scene(PICK_PLAYER_PATH)

func change_to_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func save_checkpoint(checkpoint_id: String, player_key: String = selected_player_key) -> void:
	checkpoint_ids_by_player[player_key] = checkpoint_id
	if player_key == selected_player_key:
		current_checkpoint_id = checkpoint_id
	save_checkpoint_data()

func has_checkpoint(player_key: String = selected_player_key) -> bool:
	return checkpoint_ids_by_player.has(player_key)

func get_checkpoint_id(player_key: String = selected_player_key) -> String:
	return checkpoint_ids_by_player.get(player_key, "")

func clear_checkpoint(player_key: String) -> void:
	checkpoint_ids_by_player.erase(player_key)
	if player_key == selected_player_key:
		current_checkpoint_id = ""
	save_checkpoint_data()

func clear_all_checkpoints() -> void:
	checkpoint_ids_by_player.clear()
	current_checkpoint_id = ""
	save_checkpoint_data()

func is_player_unlocked(player_key: String) -> bool:
	return unlocked_players.get(player_key, false)

func unlock_player(player_key: String) -> void:
	unlocked_players[player_key] = true
	save_checkpoint_data()

func unlock_next_player_after_boss() -> void:
	match selected_player_key:
		NORMAL_FOX:
			unlock_player(AQUA_FOX)
		AQUA_FOX:
			unlock_player(JUNGLE_FOX)

func save_checkpoint_data() -> void:
	SaveSystem.save_checkpoint_data({
		"version": 2,
		"checkpoint_ids_by_player": checkpoint_ids_by_player,
		"unlocked_players": unlocked_players,
	})

func load_checkpoint_data() -> void:
	var data := SaveSystem.load_checkpoint_data()
	if data.is_empty():
		return
	var loaded_unlocks = data.get("unlocked_players", {})
	if loaded_unlocks is Dictionary:
		for key in loaded_unlocks.keys():
			unlocked_players[key] = loaded_unlocks[key]
	if data.get("version", 1) != 2:
		return
	var loaded_checkpoints = data.get("checkpoint_ids_by_player", {})
	if loaded_checkpoints is Dictionary:
		checkpoint_ids_by_player = loaded_checkpoints
	current_checkpoint_id = get_checkpoint_id(selected_player_key)

func clear_checkpoint_data() -> void:
	checkpoint_ids_by_player.clear()
	current_checkpoint_id = ""
	unlocked_players = {
		NORMAL_FOX: true,
		AQUA_FOX: false,
		JUNGLE_FOX: false,
	}
	SaveSystem.delete_save_file()
