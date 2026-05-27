class_name EnemyCharacter
extends BaseCharacter

@export_enum("Idle","Run","VerticleMove","HorizontalMove") var start_state: String = "Idle"
@export var vertical_direction: int = -1

# Raycast check wall and fall
var front_ray_cast: RayCast2D;
var vertical_ray_cast: RayCast2D;

# detect player area
var detect_player_area: Area2D;
var found_player: Player = null

var hurt_area: Area2D
var hit_area: Area2D
var main_collision: CollisionShape2D
var player_jumped:bool = false

func _ready() -> void:
	main_collision = $CollisionShape2D
	_init_ray_cast()
	_init_detect_player_area()
	_init_hurt_area()
	_init_hit_area()
	_init_start_state()
	super._ready()

func _update_movement(delta:float):
	move_and_slide()

#init ray cast to check wall and fall
func _init_ray_cast():
	if has_node("Direction/FrontRayCast2D"):
		front_ray_cast = $Direction/FrontRayCast2D
	if has_node("Direction/VerticalRayCast2D"):
		vertical_ray_cast = $Direction/VerticalRayCast2D
		if vertical_direction == 1:
			vertical_ray_cast.rotation = PI
		elif vertical_direction == -1:
			vertical_ray_cast.rotation = 0
		else:
			print_debug('Error! Vertical Direction must be 1 or -1')


#init detect player area
func _init_detect_player_area():
	if has_node("Direction/DetectPlayerArea2D"):
		detect_player_area = $Direction/DetectPlayerArea2D
		detect_player_area.body_entered.connect(_on_body_entered)
		detect_player_area.body_exited.connect(_on_body_exited)

# init hurt area
func _init_hurt_area():
	if has_node("Direction/HurtArea2D"):
		hurt_area = $Direction/HurtArea2D
		hurt_area.hurt.connect(_on_hurt_area_2d_hurt)

func _init_hit_area():
	if has_node("Direction/HitArea2D"):
		hit_area = $Direction/HitArea2D

func _init_start_state():
	var initial_state := get_state_by_name(start_state)
	if initial_state != null:
		fsm = FSM.new(self, $States, initial_state)

func get_state_by_name(state_name: String) -> EnemyState:
	return $States.get_node_or_null(state_name) as EnemyState

func get_start_state() -> EnemyState:
	return get_state_by_name(start_state)
		
# check touch wall
func is_touch_wall() -> bool:
	if front_ray_cast != null:
		return front_ray_cast.is_colliding()
	return false

# check can fall
func is_can_fall() -> bool:
	if vertical_ray_cast != null:
		return not vertical_ray_cast.is_colliding()
	return false

#enable check player in sight
func enable_check_player_in_sight() -> void:
	if(detect_player_area != null):
		detect_player_area.get_node("CollisionShape2D").disabled = false

#disable check player in sight
func disable_check_player_in_sight() -> void:
	if(detect_player_area != null):
		detect_player_area.get_node("CollisionShape2D").disabled = true

func _on_body_entered(_body: CharacterBody2D) -> void:
	found_player = _body
	_on_player_in_sight(_body.global_position)

func _on_body_exited(_body: CharacterBody2D) -> void:
	found_player = null
	_on_player_not_in_sight()

func _on_hurt_area_2d_hurt(_direction: Vector2, _damage: float) -> void:
	if found_player == null:
		_take_damage_from_dir(_direction, _damage)
		return
	if found_player.fsm.previous_state == found_player.fsm.states.jump or found_player.fsm.current_state == found_player.fsm.states.fall or found_player.fsm.previous_state == found_player.fsm.states.fall :
		found_player.jump()
	_take_damage_from_dir(_direction, _damage)



# called when player is in sight
func _on_player_in_sight(_player_pos: Vector2):
	pass

# called when player is not in sight
func _on_player_not_in_sight():
	pass

func _take_damage_from_dir(_damage_dir: Vector2, _damage: float):	
	fsm.current_state.take_damage(_damage_dir, _damage)
	
func vertical_reversal()-> void:
	vertical_direction = - vertical_direction
	vertical_ray_cast.rotate(PI)
