extends PlayerState

func _enter() -> void:
	#Change animation to jump
	obj.change_animation('jump')

func _update(_delta: float):
	#Control moving
	control_water()
	control_dash()
	control_moving()
	control_double_jump()
	control_climb()
	if Input.is_action_just_released("jump") and obj.velocity.y < 0:
		obj.velocity.y *= 0.5
	#If velocity.y is greater than 0 change to fall
	if obj.velocity.y > 0:
		change_state(fsm.states.fall)
		
