class_name Checkpoint
extends Area2D

var is_activated: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not is_activated:
		is_activated = true
		body.set_checkpoint(global_position)
		print("Checkpoint activated at: ", global_position)
