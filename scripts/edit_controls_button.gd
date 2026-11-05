extends Button

@export var touch_controls_manager : CanvasLayer
@export var controls_editor : Panel
@export var back_button: Button
@export var gameplay_buttons : Control
func _on_pressed() -> void:
	touch_controls_manager.set_editing(true)
	controls_editor.show()
	back_button.hide()
	gameplay_buttons.show()
	gameplay_buttons.z_index = 3
	Global.is_editing_controls = true
