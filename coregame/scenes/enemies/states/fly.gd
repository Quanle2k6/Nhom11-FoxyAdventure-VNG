extends EnemyState

func _enter() -> void:
	obj.change_animation('fly')
	
func _update(delta:float) -> void:
	obj.velocity.x = obj.direction * obj.movement_speed
	if  enemy_obj().is_touch_wall() or enemy_obj().is_can_fall():
		obj.turn_around()
	
