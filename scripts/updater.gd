func _ready() -> void:
	if FileAccess.file_exists("user://update.pck"):
		ProjectSettings.load_resource_pack("user://update.pck", true)
	
