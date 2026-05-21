extends Area2D
class_name HitArea2D

@export var damage = 1
@export var hit_cooldown: float = 1.0# Thời gian chờ giữa 2 lần trừ máu

var _cooldown_timer: float = 0.0
var _bodies_in_area: Array = [] # Danh sách các vùng đang tiếp xúc

signal hitted(area)

func _init() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# Xử lý trừ máu liên tục khi đứng trong vùng
func _process(delta: float) -> void:
	if _bodies_in_area.is_empty():
		return
	if _cooldown_timer > 0:
		_cooldown_timer -= delta
		return
	for body in _bodies_in_area:
		hit(body)
	_cooldown_timer = hit_cooldown

# Gây sát thương cho vùng bị trúng
func hit(hurt_area):
	if hurt_area.has_method("take_damage"):
		var hit_dir: Vector2 = hurt_area.global_position - global_position
		hurt_area.take_damage(hit_dir.normalized(), damage)


# Khi chạm vào vùng: trừ máu ngay và bắt đầu cooldown
func _on_area_entered(area: Area2D) -> void:
	hit(area)
	_bodies_in_area.append(area)
	_cooldown_timer = hit_cooldown
	hitted.emit(area)

# Khi rời khỏi vùng: xóa khỏi danh sách
func _on_area_exited(area: Area2D) -> void:
	_bodies_in_area.erase(area)
