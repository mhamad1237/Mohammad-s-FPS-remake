extends Button

@export var back_button : Button
@export var gameplay_buttons : Control
func _on_pressed() -> void:
	get_parent().get_parent().hide()
	back_button.show()
	gameplay_buttons.hide()
	gameplay_buttons.z_index = 0
	Global.is_editing_controls = false
