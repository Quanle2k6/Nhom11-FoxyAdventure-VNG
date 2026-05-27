extends Area2D
class_name Checkpoint


#signal when checkpoint is activated
signal checkpoint_activated(checkpoint_id: String)


@export var checkpoint_id: String = ""


var is_activated: bool = false


func _ready() -> void:
	if checkpoint_id.is_empty():
		checkpoint_id = str(get_path())
	# Check if this checkpoint was already activated
	if GameManager.current_checkpoint_id == checkpoint_id:
		activate_visual_only()


func _on_body_entered(body: Node2D) -> void:
	# Only activate if it's the player
	if body is Player:
		activate()


#activate checkpoint
func activate() -> void:
	if is_activated:
		return
	is_activated = true
	GameManager.save_checkpoint(checkpoint_id)
	checkpoint_activated.emit(checkpoint_id)
	print("Checkpoint activated: ", checkpoint_id)
	AudioManager.play_sound("key_collect")


#activate checkpoint visually without saving
func activate_visual_only() -> void:
	is_activated = true
	# Need animation for already activated checkpoints
