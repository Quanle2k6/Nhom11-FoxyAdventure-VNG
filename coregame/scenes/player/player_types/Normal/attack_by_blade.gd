extends PlayerState
func get_hitbox():
	return obj.get_node("Direction/HitArea2D/HitBox2D")

func _enter() -> void:
	timer = 0.5
	obj.change_animation("attackblade")
	get_hitbox().set_deferred("disabled", false)
	obj.stop_move()


func _update(delta: float) -> void:
	if obj.is_in_water >= 1:
		obj.global_position.y = obj.water_surface_y
		obj.velocity.y = 0
	if not update_timer(delta):
		return
	if obj.is_in_water >= 1:
		change_state(fsm.states.float)
	else:
		change_state(fsm.states.idle)
	

func _exit() ->void:
	get_hitbox().set_deferred("disabled", true)
	obj.mark_attack_completed()
