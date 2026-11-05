extends Panel

@export var grenade_icon: Texture2D

@onready var ammo_label : Label = $Ammo
@onready var grenades : HBoxContainer = $Grenades
@onready var icon : TextureRect = $Icon
func _ready() -> void:
	while Global.weapon_holder == null:
		await get_tree().process_frame

	Global.weapon_holder.weapon_changed.connect(apply_icon_values)
	apply_icon_values()
func apply_icon_values():
	icon.size = Global.weapon_holder.current_weapon_data.icon_size
	icon.position = Global.weapon_holder.current_weapon_data.icon_pos
	icon.texture = Global.weapon_holder.current_weapon_data.icon

## Called through the "hud" group from the player's _ready.
func bind_player(player: Node) -> void:
	if not player.is_multiplayer_authority():
		return
	if not player.grenades_changed.is_connected(_set_grenades):
		player.grenades_changed.connect(_set_grenades)
	_set_grenades(player.grenade_count)

func _set_grenades(count: int) -> void:
	# Remove extras from the end.
	while grenades.get_child_count() > count:
		var last := grenades.get_child(grenades.get_child_count() - 1)
		grenades.remove_child(last)
		last.queue_free()
	# Add missing icons.
	while grenades.get_child_count() < count:
		var rect := TextureRect.new()
		rect.texture = grenade_icon
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grenades.add_child(rect)

func _process(delta: float) -> void:
	if is_multiplayer_authority():
		ammo_label.text = str(Global.weapon_holder.current_ammo)+ "/" + str(Global.weapon_holder.current_weapon_data.magazine_size)
