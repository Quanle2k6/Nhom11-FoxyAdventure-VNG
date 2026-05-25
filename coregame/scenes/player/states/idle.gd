extends PlayerState

## Idle state for player character
func _enter() -> void:
	obj.change_animation("idle")
	print("idle")


func _update(delta: float) -> void:
	control_attack_by_blade()
	#Control swim
	control_water()
	#Control jump
	control_jump()
	#Control moving
	control_moving()
	#If not on floor change to fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
