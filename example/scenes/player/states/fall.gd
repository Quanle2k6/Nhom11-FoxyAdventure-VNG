extends PlayerState

func _enter() -> void:
	#Change animation to fall
	obj.change_animation('fall')

func _update(_delta: float) -> void:
	#Control moving
	if control_water(): return
	control_dash()
	control_moving()
	control_climb()
	print(obj.velocity.x)
	if fsm.previous_state != fsm.states.doublejump:
		control_double_jump()
	if obj.is_on_floor():
		change_state(fsm.states.idle)
