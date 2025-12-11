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
	$CRT/Control/ColorRect.material.set_shader_parameter("aberration", 0.001)  # Clear tween here to prevent spam-jump glitch
	%ThankYou.text += "\n\ntime taken: %.2f\n\ntotal lines: %d" % [20.0 - Manager.final_time, Manager.total_lines]
