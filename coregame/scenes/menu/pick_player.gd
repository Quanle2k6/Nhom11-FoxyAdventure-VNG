extends Control


func _on_normal_fox_pressed() -> void:
	GameData.selected_player_scene = preload("res://scenes/player/player_types/Normal/Normal_fox.tscn")
	get_tree().change_scene_to_file("res://scenes/map/level_1/map_1.tscn")

func _on_aqua_fox_pressed() -> void:
	GameData.selected_player_scene = preload("res://scenes/player/player_types/Aqua/Aqua.tscn")
	get_tree().change_scene_to_file("res://scenes/map/level_1/map_1.tscn")

func _on_jungle_fox_pressed() -> void:
	GameData.selected_player_scene = preload("res://scenes/player/player_types/Jungle/Jungle.tscn")
	get_tree().change_scene_to_file("res://scenes/map/level_1/map_1.tscn")
