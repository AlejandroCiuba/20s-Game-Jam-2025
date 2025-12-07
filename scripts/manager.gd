extends Node

var total_lines: int = 0
var final_time: float = 20.0
var mute: bool = false
var dialog_path: FileAccess = FileAccess.open("res://text/dialog.json", FileAccess.READ)
var dialog: Array = []

func fetch_dialog(seq_id: int, fetch_id: String) -> Dictionary:
	var scene_dialog: Array = dialog.filter(func(d): return d["fetch_id"] == fetch_id)
	return {"name": scene_dialog[seq_id]["name"], "text": scene_dialog[seq_id]["text"]}


func change_scene(scene: String):
	(func (): get_tree().change_scene_to_file(scene)).call_deferred()


func victory():
	(func (): get_tree().change_scene_to_file("res://scenes/screens/victory.tscn")).call_deferred()


func _init() -> void:
	dialog = JSON.parse_string(dialog_path.get_as_text())
