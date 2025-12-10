extends Control


func _on_restart_button_pressed() -> void:
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	Manager.load_random_level()


func _on_loss() -> void:
	visible = true


func _ready() -> void:
	visible = false
