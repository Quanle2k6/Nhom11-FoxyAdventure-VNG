extends Node2D

@onready var old_player := $Player
@onready var land_start_point := $StartPoint

var player: Player

func _ready() -> void:
	GameManager.register_stage(self)
	var spawn_pos := get_spawn_position()
	var parent := old_player.get_parent()

	old_player.queue_free()

	player = GameManager.selected_player_scene.instantiate()
	parent.add_child(player)
	GameManager.register_player(player)
	player.apply_spawn(spawn_pos, false)

func get_spawn_position() -> Vector2:
	var checkpoint_id := GameManager.get_checkpoint_id(GameManager.selected_player_key)
	if not checkpoint_id.is_empty():
		var checkpoint := find_checkpoint_by_id(checkpoint_id)
		if checkpoint != null:
			return checkpoint.global_position
	return land_start_point.global_position

func find_checkpoint_by_id(checkpoint_id: String) -> Checkpoint:
	for node in get_tree().get_nodes_in_group("Checkpoint"):
		if node is Checkpoint and node.checkpoint_id == checkpoint_id:
			return node
	return null
