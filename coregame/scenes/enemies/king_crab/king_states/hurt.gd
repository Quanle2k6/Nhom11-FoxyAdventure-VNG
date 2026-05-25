extends BossState

func _enter() -> void:
	enable_contact_damage()
	obj.change_animation("hurt")
	timer = obj.hurt_duration

func _update(delta: float) -> void:
	set_hurt_velocity()
	if update_timer(delta):
		stop_horizontal_velocity()
		if obj.should_shield_after_hurt:
			obj.should_shield_after_hurt = false
			change_state(fsm.states.shield)
		else:
			return_to_combat_state()

func _exit() -> void:
	stop_horizontal_velocity()
