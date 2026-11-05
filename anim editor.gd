@tool
extends EditorScript

const PLAYER_PATH := "model/AnimationPlayer"
const SOURCE_CLIP := "reload1"
const T_START := 0.5   # edit per run
const T_END := 1.3     # edit per run
const SAVE_PATH := "res://animations/shotgun_shell.res"   # change per run

func _run() -> void:
	var ap := get_scene().get_node_or_null(PLAYER_PATH) as AnimationPlayer
	if ap == null or not ap.has_animation(SOURCE_CLIP):
		push_error("AnimationPlayer or clip not found")
		return
	var src := ap.get_animation(SOURCE_CLIP)
	var out := Animation.new()
	out.length = T_END - T_START

	for i in src.get_track_count():
		var type := src.track_get_type(i)
		if type == Animation.TYPE_AUDIO or type == Animation.TYPE_BEZIER:
			continue
		var j := out.add_track(type)
		out.track_set_path(j, src.track_get_path(i))
		out.track_set_interpolation_type(j, src.track_get_interpolation_type(i))

		var first = _sample(src, i, T_START)
		if first != null:
			_put(out, j, type, 0.0, first)
			for k in src.track_get_key_count(i):
				var t := src.track_get_key_time(i, k)
				if t > T_START and t < T_END:
					_put(out, j, type, t - T_START, src.track_get_key_value(i, k))
			_put(out, j, type, out.length, _sample(src, i, T_END))
		else:
			# method tracks: copy keys in range
			for k in src.track_get_key_count(i):
				var t := src.track_get_key_time(i, k)
				if t >= T_START and t < T_END:
					out.track_insert_key(j, t - T_START, src.track_get_key_value(i, k))

	DirAccess.make_dir_recursive_absolute(SAVE_PATH.get_base_dir())
	print("Saved ", SAVE_PATH, " err=", ResourceSaver.save(out, SAVE_PATH))

func _sample(a: Animation, i: int, t: float):
	match a.track_get_type(i):
		Animation.TYPE_POSITION_3D: return a.position_track_interpolate(i, t)
		Animation.TYPE_ROTATION_3D: return a.rotation_track_interpolate(i, t)
		Animation.TYPE_SCALE_3D: return a.scale_track_interpolate(i, t)
		Animation.TYPE_VALUE: return a.value_track_interpolate(i, t)
	return null

func _put(a: Animation, j: int, type: int, t: float, v) -> void:
	match type:
		Animation.TYPE_POSITION_3D: a.position_track_insert_key(j, t, v)
		Animation.TYPE_ROTATION_3D: a.rotation_track_insert_key(j, t, v)
		Animation.TYPE_SCALE_3D: a.scale_track_insert_key(j, t, v)
		_: a.track_insert_key(j, t, v)
