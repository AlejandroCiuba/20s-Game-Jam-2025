extends Control


func _on_restart_button_pressed() -> void:
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	Manager.change_scene("res://scenes/screens/level.tscn")


func _on_loss() -> void:
	visible = true


func _ready() -> void:
	visible = false
