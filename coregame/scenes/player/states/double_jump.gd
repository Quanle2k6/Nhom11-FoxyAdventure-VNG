extends PlayerState


# Called when the node enters the scene tree for the first time.
func _enter() -> void:
	print('doublejumpd')
	obj.change_animation('jump')
	AudioManager.play_sound("player_jump")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
	#Control swim
	control_water()
	control_moving()
	if obj.velocity.y > 0:
		change_state(fsm.states.fall)
