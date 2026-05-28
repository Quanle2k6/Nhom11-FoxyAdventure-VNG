extends Control


@onready var vbox_container = $VBoxContainer
@onready var open_setting_btn = $OpenSetting
@onready var setting_node = $Setting

func _ready() -> void:
	# 1. Kết nối sự kiện click chuột của nút bánh răng vào hàm mở setting
	open_setting_btn.pressed.connect(_on_open_setting_pressed)
	
	# 2. Lắng nghe tín hiệu đóng/mở từ Node Setting
	setting_node.settings_toggled.connect(_on_settings_toggled)

# Hàm chạy khi người chơi click vào nút bánh răng OpenSetting
func _on_open_setting_pressed() -> void:
	setting_node.open_settings()

# Hàm tự động xử lý ẩn/hiện các nút của Menu dựa trên trạng thái của Setting
func _on_settings_toggled(is_open: bool) -> void:
	if is_open:
		# Nếu Setting đang MỞ -> Ẩn các nút Menu chính và ẩn luôn cả chính nó (nút bánh răng)
		vbox_container.visible = false
		open_setting_btn.visible = false
	else:
		# Nếu Setting ĐÓNG -> Hiện lại tất cả
		vbox_container.visible = true
		open_setting_btn.visible = true
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/pick_player.tscn")
func _on_exit_pressed() -> void:
	get_tree().quit()
	
