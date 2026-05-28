extends Control

func _ready() -> void:
	$AnimatedSprite2D.play()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/pick_player.tscn")
func _on_exit_pressed() -> void:
	get_tree().quit()
