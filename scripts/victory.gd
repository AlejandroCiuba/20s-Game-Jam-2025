extends CanvasLayer


func _on_pressed():
	$AudioStreamPlayer.play()


func _on_play_again_pressed() -> void:
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_title_screen_pressed() -> void:
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_file("res://scenes/start.tscn") # Replace with function body.
