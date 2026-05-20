class_name Player
extends BaseCharacter
var is_in_water: bool = false # Khai báo biến kiểm tra nước
var checkpoint_position: Vector2 = Vector2.ZERO
var spawn_position: Vector2 = Vector2.ZERO
## Player character class that handles movement, combat, and state management
var is_invulnerable: bool = false
@export var has_blade: bool = false		

func _ready() -> void:
	super._ready()
	spawn_position = global_position  # thêm dòng này		
	fsm = FSM.new(self, $States, $States/Idle)
	if has_blade:
		collected_blade()

func can_attack() -> bool:
	return has_blade

func collected_blade() -> void:
	has_blade = true
	set_animated_sprite($Direction/BladeAnimatedSprite2D)
			


func _update_movement(delta: float) -> void:
		# Bỏ qua trọng lực nếu đang ở trạng thái climb, dash HOẶC swim
	if not is_on_floor() and fsm.current_state != fsm.states.swim:
		velocity.y += delta * gravity	
	move_and_slide()

	# Hai hàm này sẽ được gọi bởi Signal body_entered/exited của Area2D (Vùng nước)
func enter_water() -> void:
	is_in_water = true

func exit_water() -> void:
	is_in_water = false
# kiểm tra đã nhận biết nước chưa
func _on_water_detection_2d_body_entered(body: Node2D) -> void:
	if body == self:
		enter_water()


func _on_water_detection_2d_body_exited(body: Node2D) -> void:
	if body == self:
		exit_water()

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos

func respawn() -> void:
	health = max_health
	is_invulnerable = false
	is_in_water = false
	velocity = Vector2.ZERO
	if checkpoint_position != Vector2.ZERO:
		global_position = checkpoint_position
	else:
		global_position = spawn_position
	fsm.change_state(fsm.states.idle)

func _on_hurt_area_2d_hurt(_direction: Variant, damage: Variant) -> void:
	print("Player nhận damage: ", damage)
	take_damage(damage)

func take_damage(damage: int) -> void:
	if is_invulnerable:
		return
	super.take_damage(damage)
	print("Health còn: ", health)
	if health <= 0:
		print("Player chết, respawn!")
		respawn()
