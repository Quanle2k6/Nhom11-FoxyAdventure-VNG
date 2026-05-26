class_name Checkpoint
extends Area2D

var activated_players: Dictionary = {}

func activate(player: Player) -> void:
	if not activated_players.has(player.player_key):
		activated_players[player.player_key] = true
		player.set_checkpoint(global_position)
		print("Checkpoint activated at: ", global_position)
