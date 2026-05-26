extends EnemyState

func _enter() -> void:
	obj.change_animation('dead')
	obj.stop_move()
	set_dead(true)
	timer = 5

func update(delta:float) -> void:
	if update_timer(delta):
		set_dead(false)
		change_state(obj.start_state)

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
