extends PlayerState
func get_hitbox():
	return obj.get_node("Direction/HitArea2D/HitBox2D")

func _enter() -> void:
	timer = 0.5
	obj.change_animation("attackblade")
	get_hitbox().set_deferred("disabled", true)
	AudioManager.play_sound("player_sword")
	obj.stop_move()


func _update(delta: float) -> void:
	if not update_timer(delta):
		return
	change_state(fsm.states.idle)
	

func _exit() ->void:
	get_hitbox().set_deferred("disabled", false)
