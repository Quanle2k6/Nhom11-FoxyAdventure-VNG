extends BossState

var _last_seen_attack_completed_time: float = -1.0

func _enter() -> void:
	enable_contact_damage()
	obj.change_animation("run")
	_last_seen_attack_completed_time = _get_target_attack_completed_time()
	timer = obj.no_attack_shoot_delay

func _update(delta: float) -> void:
	if not has_target():
		stop_horizontal_velocity()
		change_state(fsm.states.idle)
		return
	if is_target_underwater():
		patrol()
		_reset_timer_if_target_finished_attack()
		return
	face_target()
	set_run_velocity()
	_reset_timer_if_target_finished_attack()
	if enemy_obj().is_touch_wall() or enemy_obj().is_can_fall():
		stop_horizontal_velocity()
		change_state(fsm.states.skilldecide)
		return
	if update_timer(delta):
		stop_horizontal_velocity()
		change_state(fsm.states.shootclaw)

func _exit() -> void:
	stop_horizontal_velocity()

func _reset_timer_if_target_finished_attack() -> void:
	var attack_completed_time := _get_target_attack_completed_time()
	if attack_completed_time <= _last_seen_attack_completed_time:
		return
	_last_seen_attack_completed_time = attack_completed_time
	timer = obj.no_attack_shoot_delay

func _get_target_attack_completed_time() -> float:
	if not has_target() or not "last_attack_completed_time" in boss_obj().found_player:
		return -1.0
	return boss_obj().found_player.last_attack_completed_time
