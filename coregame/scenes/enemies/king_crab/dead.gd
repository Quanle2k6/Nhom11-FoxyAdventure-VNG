extends BossState

func _enter() -> void:
	obj.change_animation('dead')
	obj.stop_move()
	set_dead(true)


func set_dead(is_dead: bool):
	if enemy_obj().hurt_area and enemy_obj().hurt_area.has_node("CollisionShape2D"):
		enemy_obj().hurt_area.get_node("CollisionShape2D").set_deferred("disabled", is_dead)
	if enemy_obj().hit_area and enemy_obj().hit_area.has_node("CollisionShape2D"):
		enemy_obj().hit_area.get_node("CollisionShape2D").set_deferred("disabled", is_dead)
