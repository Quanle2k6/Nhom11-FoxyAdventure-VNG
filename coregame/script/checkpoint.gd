class_name Checkpoint
extends Area2D

var is_activated: bool = false

func activate(player: Player) -> void:
	if not is_activated:
		is_activated = true
		player.set_checkpoint(global_position)
		print("Checkpoint activated at: ", global_position)
