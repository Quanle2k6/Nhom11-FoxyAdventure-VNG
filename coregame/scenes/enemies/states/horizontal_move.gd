extends EnemyState

func _enter() -> void:
	obj.change_animation('move')

func _update(delta:float)->void:
	obj.velocity.x = obj.movement_speed * obj.direction
	if enemy_obj().is_touch_wall():
		enemy_obj().turn_around()
