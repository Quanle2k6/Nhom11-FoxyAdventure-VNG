extends BossState

var _shots_fired: int = 0

func _enter() -> void:
	stop_velocity()
	enable_contact_damage()
	if not is_target_underwater():
		face_target()
	obj.change_animation("shoot")
	AudioManager.play_sound("boss_shoot")
	_shots_fired = 0
	timer = obj.shoot_delay

func _update(delta: float) -> void:
	stop_velocity()
	if not has_target():
		change_state(fsm.states.idle)
		return
	if is_target_underwater():
		change_state(fsm.states.run)
		return
	if not update_timer(delta):
		return
	face_target()
	obj.spawn_claw_projectile_toward(get_target_position())
	_shots_fired += 1
	if _shots_fired >= obj.shoot_count:
		return_to_combat_state()
	else:
		timer = obj.shoot_delay

func _exit() -> void:
	stop_velocity()
