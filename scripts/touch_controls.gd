class_name ControlsEditor
extends CanvasLayer
const PATH := "user://touch_layout.json"
@onready var slider: HSlider = $menu/ControlsEditor/Buttons/SizeSlider
var current: Control
var defaults := {}
@onready var reset_button : Button = %ResetButton
@onready var save_button : Button = %SaveButton

func _ready():
	await get_tree().process_frame
	for c in get_tree().get_nodes_in_group("touch_controls"):
		defaults[c.name] = _pack(c)
		c.selected.connect(func(x): current = x; slider.value = x.scale.x)
	load_layout()
	slider.value_changed.connect(func(v): if current: current.scale = Vector2(v, v))
	slider.hide()
	save_button.pressed.connect(save_layout)
	reset_button.pressed.connect(reset_layout)

func _pack(c: Control) -> Dictionary:
	var vs := get_viewport().get_visible_rect().size
	return {"x": c.global_position.x / vs.x, "y": c.global_position.y / vs.y, "s": c.scale.x}

func _apply(c: Control, d: Dictionary):
	var vs := get_viewport().get_visible_rect().size
	c.global_position = Vector2(d.x * vs.x, d.y * vs.y)
	c.scale = Vector2(d.s, d.s)

func set_editing(on: bool):
	slider.visible = on
	Global.is_editing_controls = on

func save_layout():
	var data := {}
	for c in get_tree().get_nodes_in_group("touch_controls"):
		data[c.name] = _pack(c)
	FileAccess.open(PATH, FileAccess.WRITE).store_string(JSON.stringify(data))

func load_layout():
	if not FileAccess.file_exists(PATH): return
	var data = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	for c in get_tree().get_nodes_in_group("touch_controls"):
		if data.has(c.name): _apply(c, data[c.name])

func reset_layout():
	for c in get_tree().get_nodes_in_group("touch_controls"):
		_apply(c, defaults[c.name])
