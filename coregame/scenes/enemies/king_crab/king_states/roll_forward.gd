extends BossState

func _enter() -> void:
	face_target()
	obj.change_animation("roll")
	AudioManager.play_sound("boss_roll")
	enable_contact_damage()
	timer = obj.roll_duration

func _update(delta: float) -> void:
	timer -= delta
	set_roll_velocity()
	if timer <= 0 or enemy_obj().is_touch_wall() or enemy_obj().is_can_fall():
		return_to_combat_state()

func _exit() -> void:
	stop_horizontal_velocity()
	enable_contact_damage()
