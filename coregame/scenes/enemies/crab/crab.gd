extends EnemyCharacter


func _update_movement(delat:float) -> void:
	velocity.y = gravity
	move_and_slide()
