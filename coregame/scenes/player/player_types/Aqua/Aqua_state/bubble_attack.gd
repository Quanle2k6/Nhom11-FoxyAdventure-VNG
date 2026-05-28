extends PlayerState

@export var bubble_speed: float = 420.0
@export var min_bubble_speed: float = 220.0
@export var max_charge_time: float = 0.8
@export var attack_duration: float = 0.2

var _charge_time: float = 0.0
var _has_fired: bool = false
var _is_finishing: bool = false

func _enter() -> void:
	_charge_time = 0.0
	_has_fired = false
	_is_finishing = false
	obj.change_animation("idle")

func _update(delta: float) -> void:
	obj.global_position.y = obj.water_surface_y
	obj.velocity.y = 0
	control_moving()
	if _has_fired:
		return
	_charge_time = minf(_charge_time + delta, max_charge_time)
	if Input.is_action_just_released("attack") or _charge_time >= max_charge_time:
		_fire_charged_bubble()

func _fire_charged_bubble() -> void:
	if _has_fired:
		return
	_has_fired = true
	var charge_ratio := 1.0
	if max_charge_time > 0.0:
		charge_ratio = clampf(_charge_time / max_charge_time, 0.0, 1.0)
	var speed := lerpf(min_bubble_speed, bubble_speed, charge_ratio)
	obj.shoot_bubble(speed)
	obj.start_bubble_cooldown()
	AudioManager.play_sound("player_shoot")
	_finish_after_duration()

func _finish_after_duration() -> void:
	if _is_finishing:
		return
	_is_finishing = true
	await get_tree().create_timer(attack_duration).timeout
	if fsm.current_state == self:
		obj.mark_attack_completed()
		_return_to_contextual_state()

func _return_to_contextual_state() -> void:
	if obj.is_in_water >= 1:
		change_state(fsm.states.float)
	elif obj.is_on_floor():
		change_state(fsm.states.idle)
	else:
		change_state(fsm.states.fall)
