extends CanvasLayer

var names: Dictionary[String, int] = {
	"Menu": 1,
	"Manual": 2,
	"Credits": 3
}

@onready var curr: Control = $Menu


func switch_menu(n: String):
	curr.visible = false
	curr = get_child(names[n]) as Control
	curr.visible = true


func _on_pressed():
	$AudioStreamPlayer.play()


func _on_start_pressed() -> void:
	await $AudioStreamPlayer.finished
	(func (): get_tree().change_scene_to_file("res://scenes/level.tscn")).call_deferred()  # Lambda function makes call happen last to allow for sound effect


func _on_manual_pressed() -> void:
	switch_menu("Manual")


func _on_credits_pressed() -> void:
	switch_menu("Credits")


func _on_title_screen_pressed() -> void:
	switch_menu("Menu")
