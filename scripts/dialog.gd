extends Control

@export var character: String = ""
@export var text: String = ""
@export var text_time: float = 0.5


func render_text() -> void:
	for c in text:
		%Dialog.text += c
		await get_tree().create_timer(text_time, false).timeout


func _ready() -> void:

	var text_size: Vector2 = %Dialog.get_theme_font("bold_font").get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, %Dialog.get_theme_font_size("bold_font_size"))
	%DialogContainer.custom_minimum_size = text_size + Vector2(32, 32)  # 16 for the two margins and 16 for the two borders
	print_debug(%DialogContainer.custom_minimum_size, text_size)

	%Name.text = character
	%Dialog.text = ""
	render_text()
