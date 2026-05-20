extends EnemyState


func _enter() -> void:
	obj.change_animation('dead')
	obj.stop_move()
	timer = 5
	

func _update(delta: float):
	if update_timer(delta):
		fsm.change_state(enemy_obj().start_state)
		obj.health = obj.max_health
