extends PlayerState


func get_hitbox():
	return obj.get_node("Direction/HitArea2D/HitBox2D")


func _enter() -> void:

	print("attack_blade")

	obj.change_animation("attackblade")
	AudioManager.play_sound("player_attack")

	# Khi attack bắt đầu -> hitbox tắt
	get_hitbox().set_deferred("disabled", true)

	# Đợi animation attack kết thúc
	await obj.animated_sprite.animation_finished

	# Bật hitbox
	get_hitbox().set_deferred("disabled", false)

	print("enabled request")
	
	# Chờ create_timer để detect overlap
	await get_tree().create_timer(0.2).timeout

	print("really enabled:", get_hitbox().disabled)


	# Tắt lại
	get_hitbox().set_deferred("disabled", true)

	change_state(fsm.states.idle)

func _update(delta: float) -> void:

	control_moving()
	control_jump()

	if Input.is_action_just_released("attack"):
		change_state(fsm.states.idle)
