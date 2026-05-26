extends PlayerState

func _enter() -> void:
	print('jump')
	#Change animation to jump
	obj.change_animation('jump')
	AudioManager.play_sound("player_jump")

func _update(_delta: float):
	control_attack_by_blade()
	#Control swim
	control_moving()
	control_double_jump()
	if Input.is_action_just_released("jump") and obj.velocity.y < 0:
		obj.velocity.y *= 0.5
	#If velocity.y is greater than 0 change to fall
	if obj.velocity.y > 0:
		change_state(fsm.states.fall)
		
