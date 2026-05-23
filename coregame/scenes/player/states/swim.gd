extends PlayerState

func _enter() -> void:
	print('swim')
	obj.change_animation("run")


func _update(delta: float) -> void:
	control_moving_in_water()
	if not Input.is_action_pressed("jump") and not Input.is_action_pressed("down"):
		obj.velocity.y = -merge_speed
	if Input.is_action_just_released('jump') or Input.is_action_just_released('left') or Input.is_action_just_released('right') or Input.is_action_just_released('down'):
		obj.stop_move()
		change_state(fsm.states.wateridle)
