extends EnemyCharacter

@onready var claw_projectile_factory: Node2DFactory = $Direction/ProjectileFactory
@onready var near_player_area: Area2D = $Direction/NearPlayerArea2D

@export var shoot_speed: float = 320.0
@export var roll_speed: float = 110
@export var roll_duration: float = 1.5
@export var skill_decide_delay: float = 0.4
@export var shield_duration: float = 1.5
@export var hurt_duration: float = 0.35
@export var hurt_knockback_speed: float = 160.0
@export var no_attack_shoot_delay: float = 2.0

@export var shoot_count: int = 3
@export var shoot_delay: float = 0.5

# Receive damage_to_shield_threshold in damage_trigger_window timmer will make boss change to Shield
@export var damage_to_shield_threshold: int = 2 
@export var damage_trigger_window: float = 1.2 

var is_shielding: bool = false
var is_player_near: bool = false
var should_shield_after_hurt: bool = false
var last_damage_direction: Vector2 = Vector2.ZERO
var _recent_damage: float = 0.0
var _recent_damage_timer: float = 0.0

func _ready() -> void:
	near_player_area.body_entered.connect(_on_near_player_area_body_entered)
	near_player_area.body_exited.connect(_on_near_player_area_body_exited)
	super._ready()

func _update_movement(delta: float) -> void:
	if _recent_damage_timer > 0.0:
		_recent_damage_timer -= delta
		if _recent_damage_timer <= 0.0:
			_recent_damage = 0.0
	velocity.y += gravity * delta
	move_and_slide()

func _on_player_in_sight(_player_pos: Vector2):
	if fsm != null and fsm.current_state != fsm.states.dead and fsm.current_state != fsm.states.run:
		fsm.current_state.change_state(fsm.states.run)

func _on_player_not_in_sight():
	if fsm != null and fsm.current_state != fsm.states.dead:
		fsm.current_state.change_state(fsm.states.idle)

func set_hit_area_enabled(enabled: bool) -> void:
	if hit_area != null:
		hit_area.set_deferred("monitoring", enabled)
		hit_area.set_deferred("monitorable", enabled)

func set_hurt_area_enabled(enabled: bool) -> void:
	if hurt_area != null:
		hurt_area.set_deferred("monitoring", enabled)
		hurt_area.set_deferred("monitorable", enabled)

func set_shield_enabled(enabled: bool) -> void:
	is_shielding = enabled
	set_hit_area_enabled(not enabled)
	set_hurt_area_enabled(not enabled)

func _on_near_player_area_body_entered(_body: CharacterBody2D) -> void:
	is_player_near = true

func _on_near_player_area_body_exited(_body: CharacterBody2D) -> void:
	is_player_near = false

func _take_damage_from_dir(damage_dir: Vector2, damage: float):
	if is_shielding:
		return
	super._take_damage_from_dir(damage_dir, damage)
	last_damage_direction = damage_dir
	_recent_damage += damage
	_recent_damage_timer = damage_trigger_window
	if _recent_damage >= damage_to_shield_threshold and health > 0:
		_recent_damage = 0.0
		should_shield_after_hurt = true
	if health > 0 and fsm != null and fsm.current_state.has_method("request_hurt"):
		fsm.current_state.request_hurt()

func spawn_claw_projectile_toward(target_position: Vector2) -> void:
	var projectile := claw_projectile_factory.create() as ClawProjectile
	var shooting_direction := target_position - projectile.global_position
	if shooting_direction.is_zero_approx():
		shooting_direction = Vector2(direction, 0.0)
	projectile.shoot(shooting_direction, shoot_speed)
