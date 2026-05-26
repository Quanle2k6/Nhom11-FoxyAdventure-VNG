extends Node2D

@onready var start_point := $StartPoint
@onready var boss_camera := $BossCamera2D
@onready var exit_level := $ExitLevel
@onready var exit_collision_shape := $ExitLevel/CollisionShape2D

var player: Player
var boss_defeated: bool = false

func _ready() -> void:
	hide_exit_level()
	boss_camera.make_current()
	player = GameData.selected_player_scene.instantiate()
	add_child(player)
	player.apply_spawn(start_point.global_position)
	disable_player_camera()

func on_boss_defeated() -> void:
	if boss_defeated:
		return
	boss_defeated = true
	GameData.unlock_next_player_after_boss()
	show_exit_level()

func disable_player_camera() -> void:
	if player.has_node("Camera2D"):
		var player_camera := player.get_node("Camera2D") as Camera2D
		player_camera.enabled = false

func show_exit_level() -> void:
	exit_level.visible = true
	exit_level.monitoring = true
	exit_collision_shape.disabled = false

func hide_exit_level() -> void:
	exit_level.visible = false
	exit_level.monitoring = false
	exit_collision_shape.disabled = true
