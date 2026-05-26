extends Area2D

@export_file("*.tscn") var target_scene_path: String = "res://scenes/map/boss_map/boss_map.tscn"
@export_enum("land", "water") var boss_map_spawn_location: String = GameManager.BOSS_MAP_SPAWN_LAND
var is_changing_scene: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		change_to_target_scene()

func _on_area_entered(area: Area2D) -> void:
	if find_parent_player(area) != null:
		change_to_target_scene()

func find_parent_player(node: Node) -> Player:
	var current := node
	while current != null:
		if current is Player:
			return current
		current = current.get_parent()
	return null

func change_to_target_scene() -> void:
	if is_changing_scene:
		return
	is_changing_scene = true
	GameManager.change_to_boss_scene(target_scene_path, boss_map_spawn_location)
