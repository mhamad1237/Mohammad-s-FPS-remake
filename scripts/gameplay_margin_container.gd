extends MarginContainer

func _ready() -> void:
	get_viewport().size_changed.connect(_update)
	_update()

func _update() -> void:
	var safe := DisplayServer.get_display_safe_area()
	var screen := DisplayServer.screen_get_size()
	var vp := get_viewport().get_visible_rect().size
	var s := Vector2(vp.x / screen.x, vp.y / screen.y)

	add_theme_constant_override("margin_left", int(safe.position.x * s.x))
	add_theme_constant_override("margin_top", int(safe.position.y * s.y))
	add_theme_constant_override("margin_right", int((screen.x - safe.end.x) * s.x))
	add_theme_constant_override("margin_bottom", int((screen.y - safe.end.y) * s.y))
