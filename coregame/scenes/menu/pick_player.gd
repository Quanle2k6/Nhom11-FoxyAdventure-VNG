extends Control


func _on_normal_fox_pressed() -> void:
	GameData.selected_player_scene = preload("res://scenes/player/player_types/Normal/Normal_fox.tscn")
	GameData.selected_player_key = GameData.NORMAL_FOX
	get_tree().change_scene_to_file("res://scenes/map/main_map/main_map.tscn")

func _on_aqua_fox_pressed() -> void:
	GameData.selected_player_scene = preload("res://scenes/player/player_types/Aqua/Aqua.tscn")
	GameData.selected_player_key = GameData.AQUA_FOX
	get_tree().change_scene_to_file("res://scenes/map/main_map/main_map.tscn")

func _on_jungle_fox_pressed() -> void:
	GameData.selected_player_scene = preload("res://scenes/player/player_types/Jungle/Jungle.tscn")
	GameData.selected_player_key = GameData.JUNGLE_FOX
	get_tree().change_scene_to_file("res://scenes/map/main_map/main_map.tscn")
