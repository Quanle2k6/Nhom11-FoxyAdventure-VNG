extends BossState

func _enter() -> void:
	enable_contact_damage()
	obj.change_animation("run")
	timer = obj.no_attack_shoot_delay

func _update(delta: float) -> void:
	if not has_target():
		stop_horizontal_velocity()
		change_state(fsm.states.idle)
		return
	face_target()
	set_run_velocity()
	if enemy_obj().is_touch_wall() or enemy_obj().is_can_fall():
		stop_horizontal_velocity()
		change_state(fsm.states.skilldecide)
		return
	if update_timer(delta):
		stop_horizontal_velocity()
		if not is_target_underwater():
			change_state(fsm.states.shootclaw)

func _exit() -> void:
	stop_horizontal_velocity()
