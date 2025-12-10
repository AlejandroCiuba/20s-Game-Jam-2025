extends Node

var total_lines: int = 0
var final_time: float = 20.0

var dialog_path: FileAccess = FileAccess.open("res://text/dialog.json", FileAccess.READ)
var dialog: Array = []

var mute: bool = false

var curr_level: String = ""
var levels: PackedStringArray
const total_levels: int = 4
const level_folder: String = "res://scenes/screens/levels/"


func fetch_dialog(seq_id: int, fetch_id: String) -> Dictionary:
	var scene_dialog: Array = dialog.filter(func(d): return d["fetch_id"] == fetch_id)
	return {"name": scene_dialog[seq_id]["name"], "text": scene_dialog[seq_id]["text"]}


func change_scene(scene: String) -> void:
	(func (): get_tree().change_scene_to_file(scene)).call_deferred()


func load_random_level(reset: bool = true) -> void:
	if reset:
		total_lines = 0
		final_time = 20.0
	curr_level = levels[randi_range(0, len(levels) - 1)]
	change_scene(curr_level)


func victory() -> void:
	change_scene("res://scenes/screens/victory.tscn")


func _init() -> void:
	for i in range(1, total_levels + 1):
		levels.append(level_folder + ("%02d.tscn" % i))
	curr_level = levels[0]  # Mostly for debugging purposes so the restart button works
	dialog = JSON.parse_string(dialog_path.get_as_text())
