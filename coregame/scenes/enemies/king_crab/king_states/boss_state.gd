class_name BossState
extends EnemyState

func boss_obj() -> EnemyCharacter:
	return obj as EnemyCharacter

func has_target() -> bool:
	return boss_obj().found_player != null and is_instance_valid(boss_obj().found_player)

func get_target_position() -> Vector2:
	if not has_target():
		return obj.global_position
	return boss_obj().found_player.global_position

func face_target() -> void:
	if not has_target():
		return
	if boss_obj().found_player.global_position.x < obj.global_position.x - 20:
		obj.turn_left()
	elif boss_obj().found_player.global_position.x > obj.global_position.x + 20:
		obj.turn_right()

func is_player_in_land_trigger_area() -> bool:
	var current_scene := obj.get_tree().current_scene
	return current_scene != null and current_scene.has_method("is_player_in_land_trigger_area") and current_scene.is_player_in_land_trigger_area()

func stop_horizontal_velocity() -> void:
	obj.velocity.x = 0

func stop_velocity() -> void:
	obj.stop_move()

func set_run_velocity() -> void:
	obj.velocity.x = obj.movement_speed * obj.direction

func set_roll_velocity() -> void:
	obj.velocity.x = obj.direction * obj.roll_speed

func set_hurt_velocity() -> void:
	var knockback_direction :float = obj.last_damage_direction.x
	if is_zero_approx(knockback_direction):
		knockback_direction = -obj.direction
	obj.velocity.x = sign(knockback_direction) * obj.hurt_knockback_speed

func enable_contact_damage() -> void:
	if not obj.is_shielding and fsm.current_state != fsm.states.dead:
		obj.set_hit_area_enabled(true)

func return_to_combat_state() -> void:
	if has_target():
		change_state(fsm.states.run)
	else:
		change_state(fsm.states.idle)

func request_hurt() -> void:
	if fsm.current_state == fsm.states.dead or fsm.current_state == fsm.states.hurt:
		return
	change_state(fsm.states.hurt)

func choose_attack_skill() -> FSMState:
	if is_player_in_land_trigger_area():
		return fsm.states.rollforward
	return fsm.states.shootclaw
