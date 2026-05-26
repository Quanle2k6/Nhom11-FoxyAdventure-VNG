extends BossState

func _enter() -> void:
	stop_horizontal_velocity()
	enable_contact_damage()
	obj.change_animation("idle")

func _update(_delta: float) -> void:
	if has_target():
		change_state(fsm.states.run)
