extends Node2D
class_name Level

signal loss
@export var dialog: PackedScene = preload("res://scenes/ui/dialog.tscn")


func create_dialog(seq_id: int, fetch_id: String) -> Node:
	var d = dialog.instantiate()
	var p = Manager.fetch_dialog(seq_id, fetch_id)
	%UILayer/Pause.add_sibling(d)
	d.spawn_dialog(p["name"], p["text"], %Player.global_position + Vector2(0.0, -64.0 - d.dialog_size.y))
	return d


func create_dialog_timed(seq_id: int, fetch_id: String, time: float = 1.0, cutoff: bool = false) -> void:
	var d = create_dialog(seq_id, fetch_id)
	if not cutoff:
		await d.rendered
	await get_tree().create_timer(time).timeout
	d.queue_free()


func _on_loss() -> void:
	var d = create_dialog(randi_range(0, 5), "fail")  # Must be within the range of the fail dialog
	await d.rendered


func _on_ui_timeout() -> void:
	loss.emit()


func _on_victory() -> void:
	Manager.final_time = $Canvases/UILayer/Timer.curr_time as float
	create_dialog(randi_range(0, 1), "victory")
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Canvases/CRT/Control/ColorRect, "material:shader_parameter/aberration", 0.800, 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func (): $Canvases/CRT/Control/ColorRect.material.set_shader_parameter("aberration", 0.001))
	await tween.finished
	(func (): Manager.victory()).call_deferred()


func _on_terminal_other(text: String) -> void:
	var seq_id: int = -1
	match text.to_lower().strip_escapes().replace(" ", ""):
		"hello":
			seq_id = 0
		"howareyou?", "howareyou", "howru", "hru":
			seq_id = 1
		"iloveyou", "iluvyou", "iluvu", "i<3u":
			seq_id = 2
		"whoareyou", "whoareyou?", "whoru", "whoru?", \
		"whatareyou", "whatareyou?", "whatru", "whatru?":
			seq_id = 3
	if seq_id != -1:
		await create_dialog_timed(seq_id, "talk")
