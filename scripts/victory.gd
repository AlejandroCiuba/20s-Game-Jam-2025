extends CanvasLayer


func _on_pressed() -> void:
	$AudioStreamPlayer.play()


func _on_play_again_pressed() -> void:
	await $AudioStreamPlayer.finished
	Manager.load_random_level()


func _on_title_screen_pressed() -> void:
	await $AudioStreamPlayer.finished
	Manager.change_scene("res://scenes/screens/start.tscn")


func _ready() -> void:
	%ThankYou.text += "\n\nTotal Lines: %d\n\nTime Taken: %.2f" % [Manager.total_lines, 20.0 - Manager.final_time]
