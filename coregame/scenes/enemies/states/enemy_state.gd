class_name EnemyState
extends FSMState

func take_damage(_damage_dir, damage: int) -> void:
	#uncomment this to make enemies push back by dmg
	#obj.velocity.x = _damage_dir.x * 150
	obj.take_damage(damage)
	# Will uncomment this when attack with boss later, and make hurt state
	#change_state(fsm.states.hurt)
	if obj.health <= 0:
		change_state(fsm.states.dead)

func enemy_obj() -> EnemyCharacter:
	return obj as EnemyCharacter

func _update(delta:float) -> void:
	pass
