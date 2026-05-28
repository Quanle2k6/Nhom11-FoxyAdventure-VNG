extends Node2D

@onready var start_point := $LandStartPoint
@onready var boss_camera := $BossCamera2D
@onready var boss := $KingCrab
@onready var boss_health_bar := $BossHealthUI/MarginContainer/VBoxContainer/BossHealthBar
@onready var land_trigger_area := $LandTriggerArea2D
@onready var exit_level := $ExitLevel
@onready var exit_collision_shape := $ExitLevel/CollisionShape2D

var player: Player
var boss_defeated: bool = false
var _player_in_land_trigger_area: bool = false

func _ready() -> void:
	GameManager.register_stage(self)
	hide_exit_level()
	boss_camera.make_current()
	player = GameManager.selected_player_scene.instantiate()
	add_child(player)
	GameManager.register_player(player)
	player.apply_spawn(start_point.global_position, false)
	disable_player_camera()
	setup_boss_health_bar()
	setup_land_trigger_area()

func setup_land_trigger_area() -> void:
	land_trigger_area.body_entered.connect(_on_land_trigger_area_body_entered)
	land_trigger_area.body_exited.connect(_on_land_trigger_area_body_exited)
	_player_in_land_trigger_area = land_trigger_area.overlaps_body(player)

func is_player_in_land_trigger_area() -> bool:
	return _player_in_land_trigger_area

func _on_land_trigger_area_body_entered(body: Node2D) -> void:
	if body == player:
		_player_in_land_trigger_area = true

func _on_land_trigger_area_body_exited(body: Node2D) -> void:
	if body == player:
		_player_in_land_trigger_area = false

func setup_boss_health_bar() -> void:
	boss_health_bar.max_value = boss.max_health
	boss_health_bar.value = boss.health
	boss.health_changed.connect(_on_boss_health_changed)

func _on_boss_health_changed(current_health: int, max_health: int) -> void:
	boss_health_bar.max_value = max_health
	boss_health_bar.value = max(current_health, 0)

func on_boss_defeated() -> void:
	if boss_defeated:
		return
	boss_defeated = true
	boss_health_bar.get_parent().get_parent().visible = false
	GameManager.unlock_next_player_after_boss()
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
