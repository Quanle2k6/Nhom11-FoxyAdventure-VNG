class_name Water
extends Area2D

var surface_y: float = 0.0

func _ready() -> void:
	# Lấy tọa độ Y của cạnh trên cùng của CollisionShape (mặt nước)
	var shape = $CollisionShape2D.shape
	surface_y = $CollisionShape2D.global_position.y - (shape.size.y / 2)
