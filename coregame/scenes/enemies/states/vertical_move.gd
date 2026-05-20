extends EnemyState

func _enter() -> void:
	obj.change_animation('move')
	
func _update(delta:float) -> void:
	obj.velocity.y = obj.movement_speed * -enemy_obj().vertical_direction
	if not enemy_obj().is_can_fall():
		enemy_obj().vertical_reversal()
