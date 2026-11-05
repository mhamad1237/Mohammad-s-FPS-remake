extends editable_control

@export var menu : Panel
@export var back_button : Button
func _on_pressed() -> void:
	menu.show()
	back_button.mode = "menu"
	back_button.show()
	Global.player.set_debug_buttons_visible(false)
