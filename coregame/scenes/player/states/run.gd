extends PlayerState

func _enter() -> void:
	#Change animation to run
	obj.change_animation('run')
	pass

func _update(delta: float):
	#Control jump
	control_jump()
	#Control moving and if not moving change to idle
	control_moving()
	if Input.is_action_just_released("left") or Input.is_action_just_released('right'):
		change_state(fsm.states.idle)
	#If not on floor change to fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
