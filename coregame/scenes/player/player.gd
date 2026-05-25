class_name Player
extends BaseCharacter
var is_in_water: int = 0 
var water_area:Water = null
var water_surface_y: float = 0.0
var checkpoint_position: Vector2 = Vector2.ZERO
var spawn_position: Vector2 = Vector2.ZERO
## Player character class that handles movement, combat, and state management
var is_invulnerable: bool = false
@export var has_blade: bool = false


func _ready() -> void:
	super._ready()
	spawn_position = global_position  	
	fsm = FSM.new(self, $States, $States/Idle)
	if has_blade:
		collected_blade()
	$Direction/HitArea2D.hitted.connect(_on_hit_area_hitted)
	$Direction/WaterDetectionArea2D.area_entered.connect(_on_water_ditection_area_2d_area_entered)
	$Direction/WaterDetectionArea2D.area_exited.connect(_on_water_ditection_area_2d_area_exitted)


func can_attack() -> bool:
	return has_blade

func collected_blade() -> void:
	has_blade = true
	set_animated_sprite($Direction/BladeAnimatedSprite2D)


func _update_movement(delta: float) -> void:
	# Bỏ qua trọng lực nếu đang ở trạng thái swim
	if not is_on_floor() and fsm.current_state != fsm.states.swim and fsm.current_state != fsm.states.wateridle and fsm.current_state != fsm.states.float :
		velocity.y += delta * gravity
	move_and_slide()

func _on_water_ditection_area_2d_area_entered(area: Area2D):
	enter_water(area)
	
func _on_water_ditection_area_2d_area_exitted(area: Area2D):
	if is_in_water > 0:
		is_in_water -= 1
	if is_in_water == 0:
		exit_water()

func enter_water(area: Area2D) -> void:
	is_in_water += 1 
	water_area = area
	if area is Water:
		water_surface_y = area.surface_y

func exit_water() -> void:
	water_area = null 
	water_surface_y = 0.0
	if fsm.current_state in [fsm.states.swim, fsm.states.wateridle, fsm.states.float]:
		fsm.change_state(fsm.states.idle)

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos

func respawn() -> void:
	health = max_health
	is_invulnerable = false
	is_in_water = 0
	velocity = Vector2.ZERO
	if checkpoint_position != Vector2.ZERO:
		global_position = checkpoint_position
	else:
		global_position = spawn_position
	fsm.change_state(fsm.states.idle)

func _on_hurt_area_2d_hurt(_direction: Variant, damage: Variant) -> void:
	take_damage(damage)

func take_damage(damage: int) -> void:
	if is_invulnerable:
		return
	super.take_damage(damage)
	if health <= 0:
		respawn()

func _on_hit_area_hitted(area: Area2D) -> void:
	if area is Checkpoint:
		area.activate(self)
	
