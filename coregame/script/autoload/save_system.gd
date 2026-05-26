extends Node

const SAVE_PATH := "user://checkpoint_save.dat"

func save_checkpoint_data(data: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file for writing: %s" % FileAccess.get_open_error())
		return
	file.store_var(data)

func load_checkpoint_data() -> Dictionary:
	if not has_save_file():
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file for reading: %s" % FileAccess.get_open_error())
		return {}
	var data = file.get_var()
	if data is Dictionary:
		return data
	return {}

func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func delete_save_file() -> void:
	if not has_save_file():
		return
	var error := DirAccess.remove_absolute(SAVE_PATH)
	if error != OK:
		push_error("Failed to delete save file: %s" % error)
