extends Area2D

@export_file("*.tscn") var target_scene_path: String = "res://scenes/map/boss_map/boss_map.tscn"
var is_changing_scene: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node) -> void:
		change_to_target_scene()

func _on_area_entered(area: Area2D) -> void:
		change_to_target_scene()

func change_to_target_scene() -> void:
	if is_changing_scene:
		return
	is_changing_scene = true
	get_tree().change_scene_to_file(target_scene_path)
