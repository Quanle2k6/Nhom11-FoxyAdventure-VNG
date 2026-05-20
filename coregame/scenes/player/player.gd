class_name Player
extends BaseCharacter
var is_in_water: bool = false # Khai báo biến kiểm tra nước
## Player character class that handles movement, combat, and state management
var is_invulnerable: bool = false
@export var has_blade: bool = false

func _ready() -> void:
	super._ready()
	fsm = FSM.new(self, $States, $States/Idle)
	if has_blade:
		collected_blade()

func can_attack() -> bool:
	return has_blade

func collected_blade() -> void:
	has_blade = true
	set_animated_sprite($Direction/BladeAnimatedSprite2D)
			
func _on_hurt_area_2d_hurt(_direction: Variant, _damage: Variant) -> void:
	fsm.current_state.take_damage(_damage)

func _update_movement(delta: float) -> void:
	# Bỏ qua trọng lực nếu đang ở trạng thái swim
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
