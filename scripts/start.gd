extends CanvasLayer

var names: Dictionary[String, int] = {
	"Menu": 1,
	"Manual": 2,
	"Credits": 3
}

@onready var curr: Control = $Menu


func switch_menu(n: String) -> void:
	curr.visible = false
	curr = get_child(names[n]) as Control
	curr.visible = true


func _on_pressed() -> void:
	$AudioStreamPlayer.play()


func _on_start_pressed() -> void:
	await $AudioStreamPlayer.finished
	Manager.load_random_level()


func _on_manual_pressed() -> void:
	switch_menu("Manual")


func _on_credits_pressed() -> void:
	switch_menu("Credits")


func _on_title_screen_pressed() -> void:
	switch_menu("Menu")


func _ready() -> void:
	$Menu.visible = true
	$Manual.visible = false
	$Credits.visible = false
