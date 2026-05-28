extends BossState

func _enter() -> void:
	stop_velocity()
	enable_contact_damage()
	obj.change_animation("idle")
	if not is_target_underwater():
		face_target()
	timer = obj.skill_decide_delay

func _update(delta: float) -> void:
	stop_velocity()
	if not has_target():
		change_state(fsm.states.idle)
		return
	if is_target_underwater():
		change_state(fsm.states.run)
		return
	face_target()
	if not update_timer(delta):
		return
	change_state(choose_attack_skill())
