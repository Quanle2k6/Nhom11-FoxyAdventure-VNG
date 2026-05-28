class_name Player
extends BaseCharacter
var is_in_water: int = 0
var water_area:WaterDetection = null
var water_surface_y: float = 0.0
var spawn_position: Vector2 = Vector2.ZERO
var player_key: String = ""
var last_attack_completed_time: float = -1.0
## Player character class that handles movement, combat, and state management
var is_invulnerable: bool = false
var count_time_in_water=0



func _ready() -> void:
	super._ready()
	print(has_node("Direction/DetectEnemyArea2D"))
	apply_spawn(global_position)
	fsm = FSM.new(self, $States, $States/Idle)
	if has_node("Direction/CheckPointDetectionArea2D"):
		$Direction/CheckPointDetectionArea2D.area_entered.connect(_on_check_point_detection_area_2d_area_entered)
	$Direction/WaterDetectionArea2D.area_entered.connect(_on_water_ditection_area_2d_area_entered)
	$Direction/WaterDetectionArea2D.area_exited.connect(_on_water_ditection_area_2d_area_exitted)



func _update_movement(delta: float) -> void:
	# Bỏ qua trọng lực nếu đang ở trạng thái swim
	if not is_on_floor() and fsm.current_state != fsm.states.swim and fsm.current_state != fsm.states.wateridle and fsm.current_state != fsm.states.float and fsm.current_state != fsm.states.attackbyblade and fsm.current_state != fsm.states.dead:
		velocity.y += delta * gravity
	move_and_slide()

func _on_water_ditection_area_2d_area_entered(area: Area2D):
	enter_water(area)



func _on_water_ditection_area_2d_area_exitted(area: Area2D):
	if is_in_water > 0:
		is_in_water -= 1

	if is_in_water == 0:
		print('check')
		exit_water()

func enter_water(area: Area2D) -> void:
	print("in water")
	is_in_water += 1
	water_area = area
	if area.is_in_group("Water"):
		water_surface_y = area.surface_y
		AudioManager.play_sound("step_water")

func exit_water() -> void:
	water_area = null
	water_surface_y = 0.0
	if fsm.current_state in [fsm.states.swim, fsm.states.wateridle, fsm.states.float]:
		fsm.change_state(fsm.states.idle)

func apply_spawn(pos: Vector2, _use_checkpoint: bool = true) -> void:
	spawn_position = pos
	player_key = GameManager.selected_player_key
	global_position = spawn_position

func _on_hurt_area_2d_hurt(_direction: Variant, damage: Variant) -> void:
	take_damage(damage)
	AudioManager.play_sound("player_hurt")

func take_damage(damage: int) -> void:
	if is_invulnerable:
		return
	super.take_damage(damage)
	if health <= 0:
		fsm.change_state(fsm.states.dead)

func mark_attack_completed() -> void:
	last_attack_completed_time = Time.get_ticks_msec() / 1000.0

func _on_check_point_detection_area_2d_area_entered(area: Area2D) -> void:
	if area is Checkpoint:
		area.activate()
	elif area.has_method("change_to_target_scene"):
		area.change_to_target_scene()
