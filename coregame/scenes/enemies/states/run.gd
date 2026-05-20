extends EnemyState

func _enter() -> void:
	obj.change_animation("run")
	
func _update(delta:float)->void:
	obj.velocity.x = obj.movement_speed * obj.direction
	if enemy_obj().is_can_fall() or enemy_obj().is_touch_wall():
		enemy_obj().turn_around()
