extends Node2D

signal loss
@export var dialog: PackedScene = preload("res://scenes/ui/dialog.tscn")


func create_dialog(seq_id: int, fetch_id: String) -> Node:
	var d = dialog.instantiate()
	var p = Manager.fetch_dialog(seq_id, fetch_id)
	%UILayer/Pause.add_sibling(d)
	d.spawn_dialog(p["name"], p["text"], %Player.global_position + Vector2(0.0, -64.0 - d.dialog_size.y))
	return d


func _on_loss() -> void:
	var d = create_dialog(randi_range(0, len(Manager.dialog) - 1), "fail")
	await d.rendered
	#d.queue_free()  # Don't know if I want this to go away or notr


func _on_gate_player_entered() -> void:
	Manager.final_time = $Canvases/UILayer/Timer.curr_time as float
	Manager.victory()


func _on_ui_timeout() -> void:
	loss.emit()


func _on_terminal_other(text: String) -> void:
	var d = null
	match text:
		"hello":
			d = create_dialog(0, "talk")
			await d.rendered
			await get_tree().create_timer(1.0).timeout
			d.queue_free()
		"how are you?", "how are you", "how r u", "hru":
			d = create_dialog(1, "talk")
			await d.rendered
			await get_tree().create_timer(1.0).timeout
			d.queue_free()
		"i love you", "i luv you", "i luv u", "i <3 u":
			d = create_dialog(2, "talk")
			await d.rendered
			await get_tree().create_timer(1.0).timeout
			d.queue_free()
