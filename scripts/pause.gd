extends Control

signal paused
signal unpaused


func _on_pressed():
	$AudioStreamPlayer.play()


func _on_pause_button_pressed() -> void:
	$Pause.visible = false
	get_tree().paused = true
	$Resume.visible = true
	paused.emit()


func _on_resume_button_pressed() -> void:
	$Pause.visible = true
	get_tree().paused = false
	$Resume.visible = false
	unpaused.emit()


func _on_restart_button_pressed() -> void:
	await $AudioStreamPlayer.finished
	get_tree().paused = false
	Manager.change_scene("res://scenes/screens/level.tscn")


func _on_loss() -> void:
	$Pause.visible = false
	$Resume.visible = false


func _ready() -> void:
	$Pause.visible = true
	$Resume.visible = false
