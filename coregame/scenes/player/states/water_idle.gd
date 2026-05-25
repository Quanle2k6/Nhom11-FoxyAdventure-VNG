extends PlayerState


func _enter() -> void:
	print('wateridle')
	obj.change_animation("idle")
	timer = 0.5

func _update(delta:float)->void:
	if obj.global_position.y <= obj.water_surface_y:
		fsm.change_state(fsm.states.float)
	control_moving_in_water()
	if  update_timer(delta):
		obj.velocity.y = - merge_speed

	
