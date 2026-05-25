extends PlayerState

func _enter() -> void:
	print('fall')
	#Change animation to fall
	obj.change_animation('fall')

func _update(_delta: float) -> void:
	control_attack_by_blade()
	control_water()
	#Control moving
	control_moving()
	if fsm.previous_state != fsm.states.doublejump:
		control_double_jump()
	if obj.is_on_floor():
		change_state(fsm.states.idle)
