extends Marker2D
class_name Node2DFactory

signal created(product)

@export var product_packed_scene: PackedScene
@export var target_container_name: StringName

func create(_product_packed_scene := product_packed_scene) -> Node2D:
	var product: Node2D = _product_packed_scene.instantiate()
	product.global_position = global_position

	var target_container := _get_target_container()
	target_container.add_child(product)

	created.emit(product)
	return product

func _get_target_container() -> Node:
	if target_container_name.is_empty():
		return get_tree().current_scene
	var stage := find_parent("Stage")
	if stage == null:
		return get_tree().current_scene
	var container := stage.find_child(target_container_name)
	if container == null:
		return get_tree().current_scene
	return container
