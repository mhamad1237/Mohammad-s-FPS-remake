extends Button
@export var back_button : Button
const SETTINGS_SCENE := preload("res://scenes/settings.tscn")  # adjust path

var _layer: CanvasLayer

func _ready() -> void:
	pressed.connect(open_settings)
	

func open_settings() -> void:
	if is_instance_valid(_layer):
		return  # already open, ignore double taps

	_layer = CanvasLayer.new()
	_layer.layer = 100  # above HUD and touch controls
	var menu := SETTINGS_SCENE.instantiate()
	menu.closed.connect(_on_settings_closed)
	_layer.add_child(menu)
	get_tree().root.add_child(_layer)
	back_button.hide()

func _on_settings_closed() -> void:
	# the menu frees itself; clean up the wrapper layer
	if is_instance_valid(_layer):
		_layer.queue_free()
	back_button.show()
