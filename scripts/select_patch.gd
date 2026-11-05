extends Button

const UPDATE_PATH := "user://update.pck"

func _ready() -> void:
	pressed.connect(_open_picker)

func _open_picker() -> void:
	# Native picker (Android/iOS/desktop), falls back to the built-in dialog
	if DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG_FILE):
		DisplayServer.file_dialog_show("Select update", "", "", false,
			DisplayServer.FILE_DIALOG_MODE_OPEN_FILE, ["*.pck"], _on_native_picked)
	else:
		var d := FileDialog.new()
		d.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		d.access = FileDialog.ACCESS_FILESYSTEM
		d.filters = ["*.pck"]
		d.use_native_dialog = true
		d.file_selected.connect(_apply_update)
		d.canceled.connect(d.queue_free)
		add_child(d)
		d.popup_centered_ratio(0.9)

func _on_native_picked(ok: bool, paths: PackedStringArray, _filter: int) -> void:
	if ok and paths.size() > 0:
		_apply_update(paths[0])

func _apply_update(path: String) -> void:
	# Copy into user:// so it can be loaded again on every launch
	if DirAccess.copy_absolute(path, UPDATE_PATH) != OK:
		push_warning("Could not copy update file")
		return
	if ProjectSettings.load_resource_pack(UPDATE_PATH, true):
		print("Update loaded")
		get_tree().reload_current_scene()  # or restart the app, see below
	else:
		push_warning("Not a valid pck")
