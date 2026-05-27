extends BossState

func _enter() -> void:
	stop_velocity()
	obj.set_shield_enabled(true)
	obj.change_animation("shield")
	AudioManager.play_sound("boss_shield")
	timer = obj.shield_duration

func _update(delta: float) -> void:
	stop_velocity()
	if not has_target():
		change_state(fsm.states.idle)
		return
	if update_timer(delta):
		change_state(choose_attack_skill())

func _exit() -> void:
	obj.set_shield_enabled(false)
