extends PlayerState

@export var attack_duration: float = 0.5
@export var hitbox_active_ratio: float = 0.6

var _elapsed_time: float = 0.0
var _hitbox_enabled: bool = false

func get_hitbox():
	return obj.get_node("Direction/AttackArea2D/HitBox2D")

func _enter() -> void:
	timer = attack_duration
	_elapsed_time = 0.0
	_hitbox_enabled = false
	get_hitbox().set_deferred("disabled", true)
	obj.change_animation("attackblade")
	AudioManager.play_sound("player_sword")
	obj.stop_move()


func _update(delta: float) -> void:
	_elapsed_time += delta
	if not _hitbox_enabled and _elapsed_time >= attack_duration * hitbox_active_ratio:
		_hitbox_enabled = true
		get_hitbox().set_deferred("disabled", false)
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
