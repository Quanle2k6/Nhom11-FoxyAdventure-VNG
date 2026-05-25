extends EnemyCharacter


func _update_movement(delat:float) -> void:
	if (fsm.current_state != fsm.states.dead):
		velocity.y = gravity
	move_and_slide()
		
