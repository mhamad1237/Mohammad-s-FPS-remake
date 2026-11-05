extends Control
class_name editable_control
signal selected(ctrl)
@onready var outline: Panel = $Outline
var edit_mode := false
var _drag := -1
var _off := Vector2.ZERO

func _ready():
	add_to_group("touch_controls")
	pivot_offset = size / 2
	outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	outline.hide()
	_sync_edit_mode()

func _process(_delta: float) -> void:
	if edit_mode != Global.is_editing_controls:
		_sync_edit_mode()

func _sync_edit_mode() -> void:
	edit_mode = Global.is_editing_controls
	_drag = -1
	for c in get_children():
		if c != outline:
			c.process_mode = Node.PROCESS_MODE_DISABLED if edit_mode else Node.PROCESS_MODE_INHERIT
	if not edit_mode:
		outline.hide()

func set_selected(on: bool):
	outline.visible = on and edit_mode

func _input(e):
	if not edit_mode: return
	if e is InputEventScreenTouch:
		if e.pressed and get_global_rect().has_point(e.position) and _drag == -1:
			_drag = e.index
			_off = global_position - e.position
			get_tree().call_group("touch_controls", "set_selected", false)
			set_selected(true)
			selected.emit(self)
			get_viewport().set_input_as_handled()
		elif not e.pressed and e.index == _drag:
			_drag = -1
	elif e is InputEventScreenDrag and e.index == _drag:
		global_position = e.position + _off
		get_viewport().set_input_as_handled()
