extends Button
@export var menu : Panel
@export var mode : String = "gameplay"
@export var gameplay_buttons : Control
func _process(delta: float) -> void:
	if mode == "gameplay":
		hide()


func _on_pressed() -> void:
	if mode == "menu":
		menu.hide()
		gameplay_buttons.show()
		mode = "gameplay"
		Global.player.set_debug_buttons_visible(true)
