class_name EnemyState
extends FSMState

func take_damage(_damage_dir, damage: int) -> void:
	obj.velocity.x = _damage_dir.x * 150
	obj.take_damage(damage)
	change_state(fsm.states.hurt)


func enemy_obj() -> EnemyCharacter:
	return obj as EnemyCharacter
