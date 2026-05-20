class_name PlayerState
extends FSMState


func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	pass
	
#Control moving and changing state to run
#Return true if moving
func control_moving() -> bool:
	var dir: float = Input.get_axis('left','right')
	var is_moving: bool = abs(dir) > 0.1
	if is_moving:
		dir = sign(dir)
		obj.change_direction(dir)
		obj.velocity.x = obj.movement_speed * dir
		if obj.is_on_floor():
			change_state(fsm.states.run)	
		return true
	else:
		if not obj.is_on_floor():
			obj.velocity.x *= 0.97
			if abs(obj.velocity.x) < 5:
				obj.velocity.x = 0
		else:
			obj.velocity.x = 0
		return false

#Control jumping
#Return true if jumping
func control_jump() -> bool:
	#If jump is pressed change to jump state and return true
	if obj.is_on_floor() and Input.is_action_just_pressed("jump"):
		obj.velocity.y = -obj.jump_speed
		change_state(fsm.states.jump)
		return true
	return false

func control_double_jump() -> bool:
	if Input.is_action_just_pressed('jump'):
		change_state(fsm.states.doublejump)
		obj.velocity.y = -obj.jump_speed
		return true
	return false
func control_water() -> bool:
	if obj.is_in_water and not obj.is_on_floor() and fsm.current_state != fsm.states.swim:
		change_state(fsm.states.swim)
		return true
	return false
	
