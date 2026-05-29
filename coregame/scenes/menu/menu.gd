extends Control

func _ready() -> void:
	$AnimatedSprite2D.play()

@onready var vbox_container = $VBoxContainer
@onready var open_setting_btn = $OpenSetting
@onready var setting_node = $Setting
@onready var foxy = $Foxy
@onready var intro =$IntroSetting
func _ready() -> void:
	# 1. K?t n?i s? ki?n click chu?t c?a nút bánh rang vào hàm m? setting
	open_setting_btn.pressed.connect(_on_open_setting_pressed)
	
	# 2. L?ng nghe tín hi?u dóng/m? t? Node Setting
	setting_node.settings_toggled.connect(_on_settings_toggled)

# Hàm ch?y khi ngu?i choi click vào nút bánh rang OpenSetting
func _on_open_setting_pressed() -> void:
	setting_node.open_settings()

# Hàm t? d?ng x? lý ?n/hi?n các nút c?a Menu d?a trên tr?ng thái c?a Setting
func _on_settings_toggled(is_open: bool) -> void:
	if is_open:
		# N?u Setting dang M? -> ?n các nút Menu chính và ?n luôn c? chính nó (nút bánh rang)
		intro.visible = false
		vbox_container.visible = false
		open_setting_btn.visible = false
		foxy.visible=false
	else:
		# N?u Setting ÐÓNG -> Hi?n l?i t?t c?
		intro.visible = true
		foxy.visible=true
		vbox_container.visible = true
		open_setting_btn.visible = true
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/pick_player.tscn")
func _on_exit_pressed() -> void:
	get_tree().quit()
	
