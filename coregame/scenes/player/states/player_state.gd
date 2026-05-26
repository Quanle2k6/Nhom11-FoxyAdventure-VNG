class_name PlayerState
extends FSMState

@export var merge_speed = 10

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
	if not fsm.states.has("doublejump"):
		return false
	if Input.is_action_just_pressed('jump'):
		change_state(fsm.states.doublejump)
		obj.velocity.y = -obj.jump_speed
		return true
	return false

func control_moving_in_water() -> bool:
	var move_dir = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("jump", "down")).normalized()
	if move_dir == Vector2.ZERO:
		if fsm.current_state != fsm.states.wateridle:
			fsm.change_state(fsm.states.wateridle)
		return false
	else:
		obj.velocity = move_dir * obj.movement_speed
		obj.change_direction(move_dir.x)
		if fsm.current_state != fsm.states.swim:
			fsm.change_state(fsm.states.swim)
		return true

func control_water() -> bool:
	if obj.is_in_water >= 1:
		if obj.global_position.y <= obj.water_surface_y:
			change_state(fsm.states.float)
		else:
			change_state(fsm.states.wateridle)
		return true
	return false
	
func control_jump_on_water() -> bool:
	if Input.is_action_just_pressed('jump'):
		obj.velocity.y = -obj.jump_speed
		change_state(fsm.states.jump)
		return true
	return false
	
func control_attack_by_blade() -> bool:
	if Input.is_action_just_pressed('attack'):
		if obj.has_method("change_to_bubble_attack"):
			obj.change_to_bubble_attack()
		else:
			change_state(fsm.states.attackbyblade)
		return true
	return false

func control_bubble_attack() ->bool:
	if Input.is_action_just_pressed('attack'):
		if obj.has_method("change_to_bubble_attack"):
			obj.change_to_bubble_attack()
		else:
			change_state(fsm.states.attackbyblade)
		return true
	return false
