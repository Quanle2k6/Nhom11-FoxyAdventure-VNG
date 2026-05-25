extends EnemyState

func _enter() -> void:
	obj.change_animation('dead')
	obj.stop_move()
	timer = 5
	set_dead(true)
		
func _update(delta: float):
	if update_timer(delta):
		fsm.change_state(enemy_obj().start_state)
		obj.health = obj.max_health
		set_dead(false)
		
func set_dead(is_dead: bool):
	enemy_obj().main_collision.set_deferred("disabled",is_dead)
	if enemy_obj().hurt_area:
		for child in enemy_obj().hurt_area.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", is_dead)

	if enemy_obj().hit_area:
		for child in enemy_obj().hit_area.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", is_dead)
