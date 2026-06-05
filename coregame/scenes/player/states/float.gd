extends PlayerState


func _enter()->void:

	obj.change_animation('run')

	
func _update(delta:float)->void:
	control_attack()
	control_jump_on_water()
	obj.global_position.y = obj.water_surface_y
	var dir: float = Input.get_axis('left', 'right')
	obj.velocity.x = dir * obj.movement_speed
	if dir != 0:
		obj.change_direction(sign(dir))
	if Input.is_action_pressed("down"):
		fsm.change_state(fsm.states.swim)
	
