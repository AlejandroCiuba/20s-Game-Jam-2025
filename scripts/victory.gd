extends CanvasLayer


func _on_pressed():
	$AudioStreamPlayer.play()


func _on_play_again_pressed() -> void:
	await $AudioStreamPlayer.finished
	Manager.change_scene("res://scenes/screens/level.tscn")


func _on_title_screen_pressed() -> void:
	await $AudioStreamPlayer.finished
	Manager.change_scene("res://scenes/screens/start.tscn") # Replace with function body.


func _ready():
	%ThankYou.text += "\n\nTotal Lines: %d\n\nFinal Time: %.2f" % [Manager.total_lines, Manager.final_time]
