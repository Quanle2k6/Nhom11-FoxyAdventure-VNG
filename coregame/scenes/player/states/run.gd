extends PlayerState

func _enter() -> void:
	print('run')
	#Change animation to run
	obj.change_animation('run')
	AudioManager.play_sound("player_run")
	await get_tree().create_timer(1.0).timeout
	AudioManager.play_sound("player_run")

	pass

func _update(delta: float):
	control_attack_by_blade()
	#Control swim
	control_water()
	#Control jump
	control_jump()
	#Control moving and if not moving change to idle
	control_moving()
	if Input.is_action_just_released("left") or Input.is_action_just_released('right'):
		change_state(fsm.states.idle)
	#If not on floor change to fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)

	
