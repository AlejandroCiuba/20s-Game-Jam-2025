extends Node

var total_lines: int = 0
var final_time: float = 20.0

var dialog_path: FileAccess = FileAccess.open("res://text/dialog.json", FileAccess.READ)
var dialog: Array = []

var mute: bool = false
var curr_level: PackedScene = null
var levels: Array[PackedScene] = [
	preload("res://scenes/screens/levels/01.tscn"),
	preload("res://scenes/screens/levels/02.tscn"),
	preload("res://scenes/screens/levels/03.tscn")
]
const level_folder: String = "res://scenes/screens/levels/"


func fetch_dialog(seq_id: int, fetch_id: String) -> Dictionary:
	var scene_dialog: Array = dialog.filter(func(d): return d["fetch_id"] == fetch_id)
	return {"name": scene_dialog[seq_id]["name"], "text": scene_dialog[seq_id]["text"]}


func change_scene(scene) -> void:
	if scene is String:
		(func (): get_tree().change_scene_to_file(scene)).call_deferred()
	elif scene is PackedScene:
		(func (): get_tree().change_scene_to_packed(scene)).call_deferred()


func load_random_level(reset: bool = true) -> void:
	if reset:
		total_lines = 0
		final_time = 20.0
	curr_level = levels[randi_range(0, len(levels) - 1)]
	(func (): get_tree().change_scene_to_packed(curr_level)).call_deferred()


func victory() -> void:
	(func (): get_tree().change_scene_to_file("res://scenes/screens/victory.tscn")).call_deferred()


func _init() -> void:
	dialog = JSON.parse_string(dialog_path.get_as_text())
